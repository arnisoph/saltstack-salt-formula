{% from "salt/map.jinja" import salt_map with context %}

{% if salt_map['manage_saltrepo'] %}
  {% if salt['grains.get']('os_family') == 'Debian' %}
salt_repo:
  pkgrepo:
    - managed
    - name: deb {{ salt_map['repo_url'] }} {{ salt_map['repo_dist'] }} {{ salt_map['repo_comps'] }}
    - file: /etc/apt/sources.list.d/salt.list
    - key_url: {{ salt_map['repo_keyurl'] }}
  {% endif %}
{% endif %}
