{% import_yaml "salt/defaults.yaml" as rawmap %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

include:
  - salt

salt-minion:
  pkg:
    - installed
    - pkgs:
{% for pkg in datamap['minion']['pkgs'] %}
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
    - dataset: {% if datamap['minion']['config'] is defined %}{{ datamap['minion']['config'] }}{% endif %}
    - formatter: YAML
    - mode: '0600'
    - user: root
    - group: root
    - require:
      - pkg: salt-minion
