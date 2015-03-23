#!jinja|yaml

{% from "salt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

include:
  - salt

salt_master:
{% if datamap.master.pkgs|length > 0 %}
  pkg:
    - installed
    - pkgs: {{ datamap.master.pkgs|default(['salt-master']) }}
    - require_in:
      - service: salt_master
{% endif %}
  service:
    - running
    - name: {{ datamap.master.service.name|default('salt-master') }}
    - enable: {{ datamap.master.service.enable|default(True) }}

{% for c in datamap.master.config.manage|default([]) %}
  {% set f = datamap['master']['config'][c]|default({}) %}
salt_master_config_{{ c }}:
  file:
    - {{ f.ensure|default('serialize') }}
    - name: {{ f.path }}
  {% if 'template_path' in f %}
    - source: {{ f.template_path }}
  {% endif %}
    - mode: {{ f.mode|default(644) }}
    - user: root
    - group: root
  {% if 'template' in f %}
    - template: {{ f.template }}
  {% endif %}
  {% if 'contents' in f %}
    - contents: {{ f.contents }}
  {% endif %}
  {% if 'dataset_pillar' in f %}
    - dataset_pillar: {{ f.dataset_pillar }}
  {% endif %}
  {% if f.ensure|default('serialize') == 'serialize' %}
    - formatter: {{ f.formatter|default('json') }}
  {% endif %}
    - watch_in:
      - service: salt_master
{% endfor %}
