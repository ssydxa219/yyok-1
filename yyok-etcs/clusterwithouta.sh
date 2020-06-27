hosts=('ddb' 'ddc' 'ddd' 'dde' 'ddf' 'ddg' 'ddh') 
if [[ $1 == "" ]];then
exit 0;
fi 
for h in ${hosts[@]}
do
echo "--------------$h----------------"
ssh $h $1
done
