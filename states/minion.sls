#!py
# -*- coding: utf-8 -*-
# vim: ts=4 sw=4 et

__formula__ = 'salt'


def run():
    config = {}
    datamap = __salt__['formhelper.get_defaults'](__formula__, __env__)
    _gen_state = __salt__['formhelper.generate_state']

    # SLS includes/ excludes
    config['include'] = datamap.get('minion', {}).get('sls_include', [])
    config['extend'] = datamap.get('minion', {}).get('sls_extend', {})

    # State salt_minion_pkgs
    if len(datamap['minion']['pkgs']) > 0:
        attrs = [
            {'pkgs': datamap['minion']['pkgs']},
            {'require_in': [{'service': 'salt_minion_service'}]},
            ]

        state_id = 'salt_minion_pkgs'
        config[state_id] = _gen_state('pkg', 'installed', attrs)

    # State salt_minion_service
    attrs = [
        {'name': datamap['minion']['service']['name']},
        {'enable': datamap['minion']['service'].get('enable', True)},
        ]

    state_id = 'salt_minion_service'
    config[state_id] = _gen_state('service', 'running', attrs)

    # States salt_minion_config
    for c in datamap['minion']['config']['manage']:
        f = datamap['minion']['config'].get(c, {})
        attrs = [
            {'name': f.get('path')},
            {'user': f.get('user', 'root')},
            {'group': f.get('group', 'root')},
            {'mode': f.get('mode', 644)},
            {'watch_in': [{'service': 'salt_minion_service'}]},
            ]

        if 'template_path' in f:
            attrs.append(dict({'template_path': f.get('template_path')}))
        if 'template' in f:
            attrs.append(dict({'template': f.get('template')}))
        if 'contents' in f:
            attrs.append(dict({'contents': f.get('contents')}))
        if 'dataset_pillar' in f:
            attrs.append(dict({'dataset_pillar': f.get('dataset_pillar')}))

        if f.get('ensure', 'serialize') == 'serialize':
            attrs.append(dict({'formatter': f.get('formatter', 'json')}))

        state_id = 'salt_minion_config_{0}'.format(c)
        config[state_id] = _gen_state('file', f.get('ensure', 'serialize'), attrs)

    return config
