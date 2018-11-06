
alias katchin_par='$(project_task_home)/buck.fbcode.datainfra.katchin/cli/katchin.par'
alias katchin_backend_par='$(project_task_home)/buck.fbcode.datainfra.katchin/backend/katchin_backend.par'
alias db_get='db -r xdb.katchin1 <<< "select concat(\"K\", test_id) from tests where cluster = \"aping1dev\" and time_created between DATE_SUB(NOW(), INTERVAL 1 HOUR) and NOW() order by test_id desc"'
