log_new_minion:
  local.cmd.run:
    - name: log new minion
    - tgt: 'master*'
    - arg:
      - 'echo "[{{ data['id'] }}][minion started] A new Minion has (re)born on $(date). Say hello to him ({{ tag }})" >> /tmp/salt.reactor.log'

tell_minion_to_install_software:
  local.state.sls:
    - name: tell minion to greet software
    - tgt: {{ data['id'] }}
    - arg:
      - saltbox.reactor_apache_httpd
