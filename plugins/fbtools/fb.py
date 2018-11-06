from __future__ import absolute_import, print_function
import json
import pdb

import datetime
import os
import subprocess
import sys
import time
import urllib
import urllib2
from xml.etree import ElementTree


INTERN_GRAPH_APP = '1599616023646150'
INTERN_GRAPH_TOKEN = 'AeMiBRhnLEUcgoWQ9KU'


# Simple caching decorator
def cache(file_name, exp=None):
    file_name = os.path.join('/tmp', 'fb.alfred_typeahead.' + file_name)
    def cache_impl(func):
        def impl(*args, **kwargs):
            try:
                if os.path.exists(file_name):
                    stat = os.stat(file_name)
                    if exp is None or time.time() - stat.st_mtime <= exp:
                        with open(file_name) as f:
                            return json.load(f)
            except:
                pass
            data = func(*args, **kwargs)
            with open(file_name, 'w') as f:
                json.dump(data, f)
                return data
        return impl
    return cache_impl


def main():
    if len(sys.argv) != 3:
        print('Usage: python fb.py CMD QUERY')
        sys.exit(1)

    cmd = sys.argv[1]
    query = sys.argv[2]
    if '-a' == sys.argv[-1]:
        if cmd == 'tasks':
            tasks = search_tasks("")
            print(render_json(tasks, json_task))
        sys.exit(0)
    if cmd == 'tasks':
        tasks = search_tasks(query)
        print(render_json(tasks, json_task))
    elif cmd == 'diffs':
        diffs = search_diffs(query)
        print(xml(diffs, xml_diff))


@cache('fbid.json')
def get_fbid():
    url = "https://interngraph.intern.facebook.com/employee/" + os.getenv('USER')
    data = {'app': INTERN_GRAPH_APP,
            'token': INTERN_GRAPH_TOKEN}
    content = urllib2.urlopen(url=url, data=urllib.urlencode(data))
    return json.load(content)['id']


@cache('tasks.json', 60)
def raw_tasks():
    url = "https://interngraph.intern.facebook.com/task/search"
    data = {'query': json.dumps({'s': [get_fbid()]}),
            'app': INTERN_GRAPH_APP,
            'token': INTERN_GRAPH_TOKEN}
    content = urllib2.urlopen(url=url, data=urllib.urlencode(data))
    return json.load(content)


code = """ 
	tell application "OmniFocus"
		parse tasks into default document with transport text {}
	end tell
        """
def search_tasks(query):
    query = query.lower()
    try:
        result = []
        raw = raw_tasks()
        for task in raw.values():
            if (query in task['title'].lower() or
                    query in task['description'].lower()):
                result.append(task)
        return sorted(result, key=lambda x: -x['updated_time'])

    except urllib2.URLError:
        return []


def call_conduit(command, args):
    cmd = subprocess.Popen([
        '/opt/facebook/bin/arc',
        'call-conduit',
        '--conduit-uri=https://phabricator.fb.com/api',
        command,
    ], stdin=subprocess.PIPE, stdout=subprocess.PIPE, env={'HOME': os.getenv('HOME')})
    stdout, stderr = cmd.communicate(json.dumps(args))
    return json.loads(stdout)['response']


@cache('phid.json')
def get_phid():
    fbid = get_fbid()
    response = call_conduit('facebook.user.find', {'fbids': [fbid]})
    return response[str(fbid)]


@cache('diffs.json', 60)
def raw_diffs():
    return call_conduit('differential.query', {
        'authors': [get_phid()],
        'limit': 200,
    })


def search_diffs(query):
    query = query.lower()
    return filter(
        lambda diff: query in diff['summary'].lower() or
        query in diff['title'].lower(),
        raw_diffs(),
    )


def xml(items, func):
    root = ElementTree.Element('items')
    for item in items:
        root.append(func(item))
    return ElementTree.tostring(root, encoding='utf-8')


def xml_task(match):
    attributes = {
        'arg': str(match['number']),
    }
    item = ElementTree.Element('item', attrib=attributes)
    ElementTree.SubElement(item, 'title').text = match['title']
    desc = match['description']
    if len(desc) == 0:
        desc = '#' + str(match['number'])
    ElementTree.SubElement(item, 'subtitle').text = desc
    ElementTree.SubElement(item, 'icon').text = 'task.png'
    return item


def xml_diff(match):
    attributes = {
        'arg': 'D' + str(match['id']),
    }
    item = ElementTree.Element('item', attrib=attributes)
    ElementTree.SubElement(item, 'title').text = match['title']
    ElementTree.SubElement(item, 'subtitle').text = match['summary'][:100]
    ElementTree.SubElement(item, 'icon').text = 'diff.png'
    return item


def render_json(items, func):
    root = {"items": []}
    for item in items:
        root["items"].append(func(item))
    return json.dumps(root)


def json_task(match):
    '''{
    "author_id": 499626523,
    "closed": false,
    "created_time": 1530137763,
    "dependent_ids": [],
    "depends_on_ids": [],
    "description": "Your ..."
    "id": 212006159440656,
    "link": "https://interngraph.intern.facebook.com/intern/tasks/?t=30982720",
    "number": 30982720,
    "owner_id": 100006751982622,
    "priority": 3,
    "subscriber_ids": {
        "100006751982622": 100006751982622,
        "499626523": 499626523
    },
    "tag_ids": [
        1899577583621685
    ],
    "title": "Reduce the size of your DotSync whitelist on devvm29138.prn1",
    "updated_time": 1530137763
    }
    @autodone(bool) - whether the item automatically completes itself when its children are complete (true) or not (false). Named to match @done.
    @context(string) - the context to assign
    @defer(date) - defer until date, e.g. 2016-04-19 5pm or next Thursday -3d
    @done(date) - completed on date
    @due(date) - due on date
    @estimate(time span) - time estimate, e.g. 2h for 2 hours or 3w for 3 weeks.
    @flagged - present when an item is flagged
    @parallel(bool) - whether children are parallel (true) or sequential (false)
    @repeat-method(method) - the repeat method: fixed, start-after-completion, or due-after-completion
    @repeat-rule(rule) - an ICS repeat rule (see RFC244557), e.g. FREQ=WEEKLY;INTERVAL=1
    '''
    def resolv_id(_id):
        return str(_id)

    d = {
        "author_id": ("creator", match['author_id']),
        "closed": ('done', datetime.datetime.fromtimestamp(match['updated_time']).strftime('%Y-%m-%d %H:%M:%S')) if match['closed'] else (),
        "modified": ('modified', datetime.datetime.fromtimestamp(match['updated_time']).strftime('%Y-%m-%d %H:%M:%S')),
        "dependent_ids": ("subtasks", ", ".join([ str(m) for m in match['dependent_ids']])),
        "depends_on_ids": ("parents", ", ".join([ str(m) for m in match['depends_on_ids']])),
        "link": ("url", match['link'] + " "),
        "task_id": ("id", match['number']),
        "tag_id": ("tags", ",".join([resolv_id(m) for m in match['tag_ids']]))
        }

    args = 'T{} - {}:\n {} {}'.format(
            str(match['number']) ,
            match['title'],
            match['description'],
            " ".join(
                ['@{}({})'.format(a[0], a[1]) for a in d.values() if a]
                )
            )

    return {
            "uid": match['number'],
            "title": match['title'],
            "arg": args,
            "subtitle": match['description'] or '#' + str(match['number']),
            "icon": 'task.png',
            }


if __name__ == '__main__':
    main()
