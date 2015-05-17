#!py
# -*- coding: utf-8 -*-
# vim: ts=4 sw=4 et

__formula__ = 'salt'


def run():
    config = {}
    datamap = __salt__['formhelper.get_defaults'](__formula__, __env__)
    _gen_state = __salt__['formhelper.generate_state']

    # SLS includes/ excludes
    config['include'] = datamap.get('ssh', {}).get('sls_include', [])
    config['extend'] = datamap.get('ssh', {}).get('sls_extend', {})

    ## State salt_ssh_pkgs
    #if len(datamap['ssh']['pkgs']) > 0:
    #    attrs = [
    #        {'pkgs': datamap['ssh']['pkgs']},
    #        {'require_in': [{'service': 'salt_ssh_service'}]},
    #        ]

    #    state_id = 'salt_ssh_pkgs'
    #    config[state_id] = _gen_state('pkg', 'installed', attrs)

    # States salt_ssh_config
    for c in datamap['ssh']['config']['manage']:
        f = datamap['ssh']['config'].get(c, {})
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
        if 'contents_grain' in f:
            attrs.append(dict({'contents': __salt__['grains.get'](f.get('contents_grain'), {})}))
        if 'contents_pillar' in f:
            attrs.append(dict({'contents_pillar': f.get('contents_pillar')}))
        if 'dataset_grain' in f:
            attrs.append(dict({'dataset': __salt__['grains.get'](f.get('dataset_grain'), {})}))
        if 'dataset_pillar' in f:
            attrs.append(dict({'dataset_pillar': f.get('dataset_pillar')}))

        if f.get('ensure', 'serialize') == 'serialize':
            attrs.append(dict({'formatter': f.get('formatter', 'json')}))

        state_id = 'salt_ssh_config_{0}'.format(c)
        config[state_id] = _gen_state('file', f.get('ensure', 'serialize'), attrs)

    return config
