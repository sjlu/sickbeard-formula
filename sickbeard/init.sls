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

sickbeard-media-folder:
  file.directory:
    - name: /var/www/media/tv
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True

sickbeard-service:
  service.enabled:
    - name: sickbeard

sickbeard-start:
  cmd.run:
    - name: /etc/init.d/sickbeard start
    - onchanges:
      - file: sickbeard-default

sickbeard-stop:
  cmd.run:
    - name: /etc/init.d/sickbeard stop
    - prereq:
      - file: sickbeard-config

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

sickbeard-restart:
  cmd.run:
    - name: /etc/init.d/sickbeard restart
    - onchanges:
      - file: sickbeard-config

sickbeard-post-processing:
  file.symlink:
    - name: /var/www/scripts/autoProcessTV.py
    - target: /var/www/sickbeard/autoProcessTV/autoProcessTV.py
    - user: www-data

sickbeard-post-processing-2:
  file.symlink:
    - name: /var/www/scripts/sabToSickBeard.py
    - target: /var/www/sickbeard/autoProcessTV/sabToSickBeard.py
    - user: www-data

sickbeard-post-processing-config:
  file.managed:
    - name: /var/www/scripts/autoProcessTV.cfg
    - source: salt://sickbeard/files/autoProcessTV.cfg
    - user: www-data
    - template: jinja

