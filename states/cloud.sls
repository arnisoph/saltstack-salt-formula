#!py
# -*- coding: utf-8 -*-
# vim: ts=4 sw=4 et

__formula__ = 'salt'


def run():
    config = {}
    datamap = __salt__['formhelper.get_defaults'](__formula__, __env__)
    _gen_state = __salt__['formhelper.generate_state']

    # SLS includes/ excludes
    config['include'] = datamap.get('cloud', {}).get('sls_include', [])
    config['extend'] = datamap.get('cloud', {}).get('sls_extend', {})

    ## State salt_cloud_pkgs
    #if len(datamap['cloud']['pkgs']) > 0:
    #    attrs = [
    #        {'pkgs': datamap['cloud']['pkgs']},
    #        {'require_in': [{'service': 'salt_cloud_service'}]},
    #        ]

    #    state_id = 'salt_cloud_pkgs'
    #    config[state_id] = _gen_state('pkg', 'installed', attrs)

    # States salt_cloud_provider_config
    for c in datamap['cloud']['config']['manage']:
        f = datamap['cloud']['config'].get(c, {})
        attrs = [
            {'name': f.get('path')},
            {'user': f.get('user', 'root')},
            {'group': f.get('group', 'root')},
            {'mode': f.get('mode', 644)},
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

        state_id = 'salt_cloud_config_{0}'.format(c)
        config[state_id] = _gen_state('file', f.get('ensure', 'serialize'), attrs)

    return config
