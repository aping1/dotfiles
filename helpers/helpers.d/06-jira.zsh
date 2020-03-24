function tasks_json () {
curl -iOL tasks.json 'https://jira-hq.paloaltonetworks.local/rest/api/2/search?jql=assignee%20=%20currentUser()%20AND%20resolution%20=%20Unresolved%20order%20by%20updated%20DESC'
}

