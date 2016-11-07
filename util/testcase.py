#!/usr/bin/env python3

import click
from jinja2 import Environment, PackageLoader

CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])

def testcase(**kwargs):
    env = Environment(loader=PackageLoader('testcase', '.'))

    test = {}
    test['name'] = kwargs['name']
    if kwargs['type']:
        test['type'] = kwargs['type']
    else:
        test['type'] = 'object'

    template = env.get_template('test-template.jnj')
    print(template.render(test=test))

@click.group(context_settings=CONTEXT_SETTINGS)
@click.version_option(version='1.0.0')
def run():
    pass

@run.command()
@click.argument('name')
@click.option('--type', default='object', help='GLib Type [object|interface|abstract]')
def add(**kwargs):
    testcase(**kwargs)

@run.command()
@click.argument('name')
def remove(**kwargs):
    testcase(**kwargs)

if __name__ == '__main__':
    run()
