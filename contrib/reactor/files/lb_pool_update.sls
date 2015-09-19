new_httpd_frontend_added_to_pool:
  local.cmd.run:
    - name: new httpd frontend added to pool
    - tgt: 'master*'
    - arg:
      - 'echo "[{{ data['id'] }}][new httpd     ] Adding new webserver ({{ data['data']['new_web_server_ip'] }}:80) to loadbalancer ({{ tag }})" >> /tmp/salt.reactor.log'
