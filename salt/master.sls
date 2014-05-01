{% from "salt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

include:
  - salt

salt-master:
  pkg:
    - installed
    - pkgs:
{% for pkg in datamap.master.pkgs %}
      - {{ pkg }}
{% endfor %}
  service:
    - running
    - name: {{ datamap.master.service.name }}
    - enable: {{ datamap.master.service.enable }}
    - watch:
      - file: /etc/salt/master
    - require:
      - pkg: salt-master
      - file: /etc/salt/master

/etc/salt/master:
  file:
    #- serialize
    #- dataset: {# if datamap['master']['config'] is defined #}{# datamap['master']['config'] #}{# endif #}
    #- formatter: YAML
    - managed
    - mode: 600
    - user: root
    - group: root
    - contents_pillar: salt:lookup:master:config
