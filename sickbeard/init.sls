python-cheetah:
  pkg.installed:
    - name: python-cheetah

sickbeard:
  git.latest:
    - name: https://github.com/midgetspy/Sick-Beard.git
    - target: /var/www/sickbeard
    - rev: master
    - submodules: true
    - user: www-data
    - require:
      - pkg: python-cheetah
      - pkg: git

sickbeard-service:
  service.running: 
    - enable: True
    - reload: True
    - name: sickbeard
    - watch:
      - file: sickbeard-config

sickbeard-stop:
  service.dead:
    - name: sickbeard

sickbeard-media-folder:
  file.directory:
    - name: /var/www/media/tv
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True

sickbeard-init:
  file.managed:
    - name: /etc/init.d/sickbeard
    - source: salt://sickbeard/files/init.ubuntu
    - user: root
    - group: root
    - mode: 755

sickbeard-default:
  file.managed:  
    - name: /etc/default/sickbeard
    - source: salt://sickbeard/files/default
    - user: root
    - group: root
    - mode: 644
    - template: jinja

sickbeard-config:
  file.managed:
    - name: /var/www/.sickbeard/config.ini
    - source: salt://sickbeard/files/config.ini
    - mode: 644
    - user: www-data
    - group: www-data
    - template: jinja
    - watch_in:
      - service: sickbeard

sickbeard-start:
  service.running:
    - name: sickbeard

