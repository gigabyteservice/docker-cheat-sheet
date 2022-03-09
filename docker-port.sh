#!/bin/bash
# All docker container IP and Ports
function dip() {
        if [ -z $1 ]; then
                docker ps -a --format "{{.ID}}" | while read -r line ; do
                        PORTS=$(docker port "$line" | grep -o "0.0.0.0:.*" | cut -f2 -d:)
                        if [ -z "${PORTS}" ]; then
                            echo $line $(docker inspect --format "{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}" $line | sed 's/\///'):" No open ports"
                        else
                            echo $line $(docker inspect --format "{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}" $line | sed 's/\///'):${PORTS}
                        fi
                done
        else
                echo $(docker inspect --format "{{.ID }} {{ .Name }} {{ .NetworkSettings.Networks.bridge.IPAddress }}" $1 | sed 's/\///'):$(docker port "$1" | grep -o "0.0.0.0:.*" | cut -f2 -d:)
        fi
}
dip
