{% import_yaml "salt/defaults.yaml" as rawmap %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

{% if datamap['manage_saltrepo'] %}
  {% if salt['grains.get']('os_family') == 'Debian' %}
salt_repo:
  pkgrepo:
    - managed
    - name: deb {{ datamap['repo_url'] }} {{ datamap['repo_dist'] }} {{ datamap['repo_comps'] }}
    - file: /etc/apt/sources.list.d/salt.list
    - key_url: {{ datamap['repo_keyurl'] }}
  {% endif %}
{% endif %}