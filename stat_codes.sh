#!/bin/sh

r1=`find app/ -name *.rb|grep -v admin|grep -v helper|grep -v locale|grep -v views|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "Controllers: \t\t%s\n" $r1
r7=`find app/ -name *helpers.rb|grep -v admin|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "Helpers: \t\t%s\n" $r7
r2=`find app/views -name *.erb|grep -v admin|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "Views: \t\t\t%s\n" $r2
r3=`find models/ -name *.rb|grep -v admin|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "Models: \t\t%s\n" $r3
r8=`find db/ -name *.rb|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "DB & Migration: \t%s\n" $r8
r9=`find config -name *.rb|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "Configuration: \t\t%s\n" $r9

r4=`find lib/ -name *.rb|grep -v admin|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "Libraries: \t\t%s\n" $r4
r5=`find test/models -name *.rb|grep -v admin|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "Unit test: \t\t%s\n" $r5
r6=`find test/app -name *.rb|grep -v admin|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "Function test: \t\t%s\n" $r6
total=`expr $r1 + $r2 + $r3 + $r4 + $r5 + $r6 + $r7 + $r8 + $r9`

printf "Ruby code Lines: \t%s\n" $total
printf "All .rb files Lines: \t%s\n" `find . -name *.rb|grep -v admin|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
echo "-----------------------------------"
s1=`find public -name *.css|grep -v admin|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
s2=`find public -name *.js|grep -v admin|xargs cat|grep -v "^\s*#"|grep -v "^\s*$" |wc -l`
printf "StyleSheets: \t\t%s\n" $s1
printf "Javascripts: \t\t%s\n" $s2
echo "-----------------------------------"
printf "Total: \t\t\t%s\n" `expr $r1 + $r2 + $r3 + $r4 + $r5 + $r6 + $r7 + $r8 + $r9 + $s2` 