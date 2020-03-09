#!python3
import json
import os
import sys
import click
import logging

# define a Handler which writes INFO messages or higher to the sys.stderr
console = logging.StreamHandler()
console.setLevel(logging.INFO)
# set a format which is simpler for console use
formatter = logging.Formatter("%(name)-12s: %(levelname)-8s %(message)s")
# tell the handler to use this format
console.setFormatter(formatter)
# add the handler to the root logger
logging.getLogger("").addHandler(console)
try:
    __IPYTHON__
    logger = logging.getLogger("ipython")
except NameError:
    logger = logging.getLogger(__file__)


class Converter(object):
    def __init__(self, allow_caps=False, filename=None, debug=None, profile=None):
        self.allow_caps = allow_caps
        if debug:
            global logger
            logging.getLogger("").setLevel(logging.DEBUG)
        self.skhdrc = os.path.abspath(
            profile or os.path.join(os.environ["HOME"], ".skhdrc")
        )

    modifications = {
        "complex_modifications": {
            "parameters": {
                "basic.to_if_alone_timeout_milliseconds": 250,
                "basic.to_if_held_down_threshold_milliseconds": 250,
            },
            "description": "This description is shown in Preferences.",
            "rules": [],
        }
    }

    def convert(self):
        def parse(line):
            keylist = line.partition(":")
            lhs, _, keycode = keylist[0].rpartition("-")
            modifiers = [
                f"left_{mod.strip()}"
                for mod in lhs.split("+")
                if mod.strip() in ["alt", "shift", "cmd", "ctrl"]
            ]
            modifiers = {"mandatory": modifiers}
            if self.allow_caps:
                modifiers["optional"] = ["caps_lock"]
            if any('"' in cmd for cmd in keylist[2]):
                logger.warning(f"Warning, escapting queote for {comment}")
            shell_command = {"shell_command": '/usr/local/bin/' + "".join(keylist[2]).strip()}
            logger.debug(
                f'sending {modifiers} for {keycode.strip()} do": {shell_command["shell_command"]}'
            )
            return keylist[0].strip(), "".join(keylist[2]), modifiers, keycode.strip(), shell_command

        logger.info(f"opening {self.skhdrc}")
        with open(self.skhdrc) as fp:
            _fp = iter(fp.readlines())
            lines = []
            comment = ""
            for line in _fp:
                line = line.strip()
                if line.startswith("#"):
                    comment = line
                    continue
                elif line.endswith("\\"):
                    lines.append(line.rstrip("\\"))
                    continue
                elif ":" not in line:
                    continue
                lines.append(line)
                creation_obj = {"type": "basic", "from": {"modifiers": {}}}
                logger.info(f"Parsing line {lines}")
                name, cmd, creation_obj["from"]["modifiers"], creation_obj["from"][
                    "key_code"
                ], creation_obj["to_if_alone"] = parse(" ".join(lines).strip())
                comment = f'{name} | {cmd.strip() if ";" not in cmd else " "}{comment}'
                yield {"description": comment, "manipulators": [creation_obj]}
                lines = []
                comment = ""


@click.option("--allow-caps", default=True, type=click.types.BoolParamType())
@click.option("--filename", default="/dev/stdout")
@click.option("--title", default="skhdrc")
@click.option("--debug/--no-debug", default=False, envvar="CONVERTER_DEBUG")
@click.argument("profile", default=os.path.join(os.environ["HOME"], ".skhdrc"))
@click.command()
def cli(ctx=None, allow_caps=False, filename=None, title=None, debug=False, profile=None):
    ctx = Converter(allow_caps=allow_caps, debug=debug, profile=profile)
    filename = os.path.abspath(filename or "/dev/stdout")
    rules = [rule for rule in ctx.convert()]
    print(json.dumps({"title": title, "rules": rules}, indent=" " * 4))


def run_from_ipython():
    try:
        __IPYTHON__
        return True
    except NameError:
        return False


try:
    cli()
except SystemExit as e:
    if not run_from_ipython and e.code != 0:
        raise
