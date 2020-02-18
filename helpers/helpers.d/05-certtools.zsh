
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
function print_cert () {
        QTYPE="x509"
        Q_ARGS="-noout"
        local cert
        seperate_certs "${REPLY:-$1}" | while read cert
        do
        printf -- '%s\n' "${cert}" | tr '|' '\n' | openssl ${QTYPE} -in /dev/stdin ${Q_ARGS} -serial -modulus -subject -issuer | tr ' ' \| | tr \\n \  | xargs jq -njR --args '{
            "filename":  $ARGS.positional[0],
            "serial":  $ARGS.positional[1],
            "modulus":  $ARGS.positional[2],
            "subject":  ( $ARGS.positional[3] | gsub("\\|";" ")),
            "issuer":  ( $ARGS.positional[4:]  | join(" ") | gsub("\\|";" ")),
            }' "${REPLY:-$1}"
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

