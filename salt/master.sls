include:
  - salt

{% from "salt/map.jinja" import salt_map with context %}

salt-master:
  pkg:
    - installed
    - pkgs:
{% for pkg in salt_map['master']['pkgs'] %}
      - {{ pkg }}
{% endfor %}
  service:
    - running
    - watch:
      - file: /etc/salt/master
    - require:
      - file: /etc/salt/master

/etc/salt/master:
  file:
    - serialize
    - dataset: {% if salt_map['master']['config'] is defined %}{{ salt_map['master']['config'] }}{% endif %}
    - formatter: YAML
    - mode: '0600'
    - user: root
    - group: root
    - require:
      - pkg: salt-master
