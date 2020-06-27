hosts=('ddb' 'ddc' 'ddd' 'dde' 'ddf' 'ddg' 'ddh')
for h in ${hosts[@]}
do
echo "--------------$h----------------"
 scp -r $1 root@$h:$2
done
