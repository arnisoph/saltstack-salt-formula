#!py
# -*- coding: utf-8 -*-
# vim: ts=4 sw=4 et

__formula__ = 'salt'


def run():
    config = {}
    datamap = __salt__['formhelper.get_defaults'](__formula__, __env__)
    _gen_state = __salt__['formhelper.generate_state']

    # SLS includes/ excludes
    config['include'] = datamap.get('syndic', {}).get('sls_include', [])
    config['extend'] = datamap.get('syndic', {}).get('sls_extend', {})

    # State salt_syndic_pkgs
    if len(datamap['syndic']['pkgs']) > 0:
        attrs = [
            {'pkgs': datamap['syndic']['pkgs']},
            {'require_in': [{'service': 'salt_syndic_service'}]},
            ]

        state_id = 'salt_syndic_pkgs'
        config[state_id] = _gen_state('pkg', 'installed', attrs)

    # State salt_syndic_service
    attrs = [
        {'name': datamap['syndic']['service']['name']},
        {'enable': datamap['syndic']['service'].get('enable', True)},
        ]

    state_id = 'salt_syndic_service'
    config[state_id] = _gen_state('service', 'running', attrs)

    return config
