include:
  - salt

{% from "salt/map.jinja" import salt_map with context %}

salt-minion:
  pkg:
    - installed
    - pkgs:
{% for pkg in salt_map['minion']['pkgs'] %}
      - {{ pkg }}
{% endfor %}
  service:
    - running
    - watch:
      - file: /etc/salt/minion
    - require:
      - file: /etc/salt/minion

/etc/salt/minion:
  file:
    - serialize
    - dataset: {% if salt_map['minion']['config'] is defined %}{{ salt_map['minion']['config'] }}{% endif %}
    - formatter: YAML
    - mode: '0600'
    - user: root
    - group: root
    - require:
      - pkg: salt-minion
