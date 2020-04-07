transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/QUARTUS/GitHub/lab04-grupo15/hdl/src {D:/QUARTUS/GitHub/lab04-grupo15/hdl/src/BCDtoSSeg.v}

