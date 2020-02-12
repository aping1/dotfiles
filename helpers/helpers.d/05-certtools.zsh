
function has_key () {
    openssl pkey -in "${REPLY:-$1}" &>/dev/null
}

function cert_purpose () {
    openssl x509 -in /dev/stdin -noout -purpose | grep 'Yes'
}

function cert_is_client () {
    openssl x509 -in /dev/stdin -noout -purpose | grep "SSL client: Yes" 2>/dev/null
}

function cert_is_server () {
    openssl x509 -in /dev/stdin -noout -purpose | grep "SSL server: Yes" 2>/dev/null
}

function cert_has_client() {
    local cert
    [[ ${REPLY:-$1} ]] && seperate_certs  "${REPLY:-$1}" | while read cert; do
        printf -- '%s\n' "${cert}" | tr '|' '\n' | cert_is_client | tee /dev/stderr
    done
}
function cert_has_server () {
    local cert
    [[ ${REPLY:-$1} ]] && seperate_certs "${REPLY:-$1}" | while read cert; do
        printf -- '%s\n' "${cert}" | tr '|' '\n' | cert_is_server | tee /dev/stderr 
    done
}

function print_key() {
    QTYPE="rsa"
    Q_ARGS="-noout"
    K_ARGS="-modulus"
    local cert
    seperate_keys "${REPLY:-$1}" | while read cert; do
        printf -- '%s\n' "${cert}" | tr '|' '\n' | openssl ${QTYPE} -in /dev/stdin ${Q_ARGS} ${K_ARGS} | tr \\n \  | xargs jq -njR --args '{
        "filename":  $ARGS.positional[0],
        "modulus":  $ARGS.positional[1],
    }' "${REPLY:-$1}"; echo  
done  
}

function reduce_cert() {
    print_cert ${REPLY:-$1} | jq -s '.[] | {(.subject.common_name): .pem}' | jq -r --slurp 'reduce .[] as $item ({}; . * $item) | to_entries | map(.value) | join("\n")'
}

function print_cert () {
    local QTYPE="x509"
    local Q_ARGS="-noout"
    local cert
    seperate_certs "${REPLY:-$1}" | while read cert; do
        if (( $+commands[cfssl] )); then
            cfssl certinfo -cert /dev/stdin <<< ${cert//|/$'\n'}
        else
            printf -- '%s\n' "${cert}" | tr '|' '\n' | openssl ${QTYPE} \
                -in /dev/stdin ${Q_ARGS} \
                -serial \
                -modulus \
                -subject \
                -issuer | tr ' ' \| | tr \\n \  | xargs jq -njR --args '{
                    "subject": {
                        "common_name": ( $ARGS.positional[3] | gsub("\\|";" ")),
                        "country": "",
                        "organization": "",
                        "names": [
                        ( $ARGS.positional[3] | gsub("\\|";" ")),
                        ]
                    },
                    "issuer": {
                    "common_name": ( $ARGS.positional[4:]  | join(" ") | gsub("\\|";" ")),
                    "country": "",
                    "organization": ""),
                    "names": [
                        ( $ARGS.positional[4:]  | join(" ") | gsub("\\|";" ")),
                        ]
                    },
                    "serial_number": $ARGS.positional[1],
                    "not_before": "",
                    "not_after": "",
                    "sigalg": "",
                    "authority_key_id": "",
                    "subject_key_id": "",
                    "pem": ""
                }' "${REPLY:-$1}"
        fi
        echo
    done
}

function pop_key () {
    openssl pkey -in "${REPLY:-$1}" 2>/dev/null
}

function pop_cert () {
    if [[ "${REPLY:-$1}" ]]; then
        openssl x509 -in "${REPLY:-$1}" -outform pem;
    else;
        openssl x509 -outform pem;
    fi
}

function seperate_keys () {
    local _DELIM='|'
    if [[ ${RETRY:-$1} ]] ; then
        seperate_keys < "${REPLY:-$1}" 
    else
        sed -n '/-----BEGIN \(RSA \)*PRIVATE KEY-----/,/-----END \(RSA \)*PRIVATE KEY-----/{/-----BEGIN \(RSA \)*PRIVATE KEY-----/!{H;/-----END \(RSA \)*PRIVATE KEY-----/!d;x;s/\n/|/g;p;};x;}' 
    fi
}

function seperate_certs () {
    local _DELIM='|'
    if [[ ${RETRY:-$1} ]] ; then
        seperate_certs < "${REPLY:-$1}" 
    else
        sed -n '/-----BEGIN \(TRUSTED \)*CERTIFICATE-----/,/-----END \(TRUSTED \)*CERTIFICATE-----/{/-----BEGIN \(TRUSTED \)*CERTIFICATE-----/!{H;/-----END \(TRUSTED \)*CERTIFICATE-----/!d;x;s/\n/|/g;p;};x;}'
    fi
}

function split_certs_into_files () {
    # Usage: split_cert <filename>
    # output is each cert, files are created as <filename>_0 <filename_1> etc...
    local BIGCERT=$1
    local _DELIM='|'
    local counter=0
    if [[ ! ${BIGCERT} ||  ! -r ${BIGCERT} ]]; then
        { echo "Failed to export: ${BIGCERT} is not valid"; return 1;}
    fi
    sed -n '/-----BEGIN \(TRUSTED \)*CERTIFICATE-----/,/-----END \(TRUSTED \)*CERTIFICATE-----/{/-----BEGIN \(TRUSTED \)*CERTIFICATE-----/!{H;/-----END \(TRUSTED \)*CERTIFICATE-----/!d;x;s/\n/|/g;p;};x;}' < "${BIGCERT}" | while read line; do printf -- '%s\n' "${line}" | tr '|' '\n' | openssl x509 -subject -issuer |   tee  "${BIGCERT}_$((counter++))"; done
}
