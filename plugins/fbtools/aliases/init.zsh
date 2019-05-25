
alias buck_prefix='echo $(project_task_home)/buck-fbcode.fbsource-fbcode.datainfra.katchin'
alias kobold_buck_prefix='echo $(project_task_home)/buck-fbcode.fbsource-fbcode.kobold.bin'
alias kobold_par='$(kobold_buck_prefix)/kobold.par'
alias katchin_par='$(buck_prefix)/cli/katchin.par'
alias katchin_backend_par='$(buck_prefix)/backend/katchin_backend.par'
alias db_get='db -r xdb.katchin1 <<< "select concat(\"K\", test_id) from tests where cluster = \"aping1dev\" and time_created between DATE_SUB(NOW(), INTERVAL 1 HOUR) and NOW() order by test_id desc"'
