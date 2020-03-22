package com.yyok.mains;

import com.yyok.crawler.model.PageRequest;
import com.yyok.common.util.JsoupUtil;
import com.yyok.common.util.UrlUtil;
import org.apache.http.client.HttpClient;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class JobMain {

    public static void main(String[] args) {

        System.out.println("正在生成客户端...");
        HttpClient client = null;
        System.out.println("客户端生成完毕.");


        String[] city = {"阿坝", "阿克苏", "阿拉尔", "阿拉善盟", "阿勒泰", "阿里", "鞍山",
                "安康", "安庆", "安顺", "安阳", "巴彦淖尔", "巴音郭楞", "巴中",
                "白城", "白沙", "白山", "白银", "百色", "蚌埠", "包头",
                "保定", "保山", "保亭", "宝鸡", "北海", "北京", "本溪",
                "毕节", "滨州", "博尔塔拉", "亳州", "沧州", "昌都", "昌吉",
                "昌江", "常德", "常熟", "常州", "长春", "长沙", "长治",
                "朝阳", "潮州", "郴州", "成都", "澄迈", "承德", "池州",
                "赤峰", "崇左", "滁州", "楚雄", "重庆", "达州", "大理", "大连", "大庆", "大同", "大兴安岭", "丹东",
                "丹阳", "德宏", "德阳", "德州", "邓州", "迪庆", "定安",
                "定西", "东方", "东营", "东莞", "儋州", "鄂尔多斯", "鄂州",
                "恩施", "防城港", "佛山", "福州", "抚顺", "抚州", "阜新",
                "阜阳", "甘南", "甘孜", "赣州", "固原", "广安", "广元",
                "广州", "桂林", "贵港", "贵阳", "果洛", "哈尔滨", "哈密", "海北", "海东", "海口", "海南", "海宁",
                "海西", "邯郸", "汉中", "杭州", "菏泽", "和田", "合肥",
                "河池", "河源", "鹤壁", "鹤岗", "贺州", "黑河", "衡水",
                "衡阳", "红河州", "呼和浩特", "呼伦贝尔", "葫芦岛", "湖州", "怀化",
                "淮安", "淮北", "淮南", "黄冈", "黄南", "黄山", "黄石",
                "惠州", "鸡西", "吉安", "吉林", "济南", "济宁", "济源", "嘉兴",
                "嘉峪关", "佳木斯", "江门", "焦作", "揭阳", "金昌", "金华",
                "锦州", "晋城", "晋中", "荆门", "荆州", "景德镇", "靖江",
                "九江", "酒泉", "喀什地区", "开封", "开平", "克拉玛依", "克孜勒苏柯尔克孜",
                "昆明", "昆山", "拉萨", "莱芜", "来宾", "兰州", "廊坊", "乐山", "丽江",
                "丽水", "连云港", "凉山", "聊城", "辽阳", "辽源", "林芝",
                "临沧", "临汾", "临高", "临夏", "临沂", "陵水", "柳州",
                "六安", "六盘水", "龙岩", "陇南", "娄底", "吕梁", "洛阳",
                "泸州", "漯河", "马鞍山", "茂名", "梅州", "眉山", "绵阳",
                "牡丹江", "那曲", "南昌", "南充", "南京", "南宁", "南平",
                "南通", "南阳", "内江", "宁波", "宁德", "怒江", "攀枝花", "盘锦", "萍乡", "平顶山", "平凉", "莆田", "普洱",
                "濮阳", "七台河", "齐齐哈尔", "黔东南", "黔南", "黔西南", "潜江",
                "钦州", "秦皇岛", "青岛", "清远", "庆阳", "琼海", "琼中",
                "曲靖", "泉州", "衢州", "日喀则", "日照", "三门峡", "三明", "三沙", "三亚", "山南", "汕头", "汕尾",
                "商洛", "商丘", "上海", "上饶", "韶关", "邵阳", "绍兴",
                "深圳", "神农架", "沈阳", "十堰", "石河子", "石家庄", "石嘴山",
                "双鸭山", "朔州", "四平", "松原", "苏州", "宿迁", "宿州",
                "随州", "绥化", "遂宁", "塔城", "台州", "泰安", "泰兴",
                "泰州", "太仓", "太原", "唐山", "天津", "天门", "天水",
                "铁岭", "通化", "通辽", "铜川", "铜陵", "铜仁", "图木舒克",
                "吐鲁番", "屯昌", "万宁", "威海", "潍坊", "渭南", "温州", "文昌", "文山",
                "乌海", "乌兰察布", "乌鲁木齐", "无锡", "芜湖", "梧州", "吴忠",
                "武汉", "武威", "五家渠", "五指山", "西安", "西昌", "西宁",
                "西双版纳", "锡林郭勒盟", "厦门", "仙桃", "咸宁", "咸阳", "襄阳",
                "湘潭", "湘西", "孝感", "新乡", "新余", "忻州", "信阳",
                "兴安盟", "邢台", "雄安新区", "徐州", "许昌", "宣城", "乐东", "雅安", "烟台", "盐城", "延安", "延边", "延吉",
                "燕郊开发区", "杨凌", "扬州", "洋浦经济开发区", "阳江", "阳泉", "伊春",
                "伊犁", "宜宾", "宜昌", "宜春", "义乌", "益阳", "银川",
                "鹰潭", "营口", "永州", "榆林", "玉林", "玉树", "玉溪",
                "岳阳", "云浮", "运城", "枣庄", "湛江", "漳州", "张家港",
                "张家界", "张家口", "张掖", "昭通", "肇庆", "镇江", "郑州",
                "中山", "中卫", "舟山", "周口", "珠海", "株洲", "驻马店",
                "资阳", "淄博", "自贡", "遵义", "广东省", "江苏省", "浙江省", "四川省", "海南省", "福建省", "山东省",
                "江西省", "广西", "安徽省", "河北省", "河南省", "湖北省", "湖南省",
                "陕西省", "山西省", "黑龙江省", "辽宁省", "吉林省", "云南省", "贵州省",
                "甘肃省", "内蒙古", "宁夏", "西藏", "新疆", "青海省", "香港",
                "澳门", "台湾", "国外"};


        String[] value = {
                "092200", "310600", "310900", "281500", "311300",
                "300800", "230400", "201000", "150400", "260500", "170900", "280900", "311800", "092000", "241000", "101800", "240900", "270800", "141100", "150600", "280400", "160400", "251200", "101700", "200400", "140500", "010000", "231000", "260700", "121500", "311900", "151800",
                "160800", "300600", "311200", "101900", "190700", "070700", "070500", "240200", "190200", "210600", "231400", "032000", "190900", "090200", "101300", "161000", "151500", "280300", "141400", "150900", "251700", "060000",
                "091700", "250500", "230300", "220500", "210400", "221400", "230800", "072100", "251600", "090600", "121300", "172000", "252000", "101100", "271100", "100900", "121000", "030800", "100800", "280800", "181000", "181800", "140800",
                "030600", "110200", "230600", "131100", "231500", "150700", "271500", "092100", "130800", "290600", "091300", "091600", "030200", "140300", "141000", "260200", "320800", "220200", "310700", "320500", "320300", "100200", "320700", "081600", "320400", "160700", "200900", "080200",
                "121400", "311600", "150200", "141200", "032100", "171700", "221000", "141500", "221200", "161200", "190500", "251000", "280200", "281100", "230900", "080900", "191100", "071900", "151700", "151100", "181100", "320600", "151000", "180400", "030300",
                "220900", "130900", "240300", "120200", "120900", "171900", "080700", "270400", "220800", "031500", "170500", "032200", "270300", "080600", "230700", "210700", "211000", "180800", "180700", "130400", "072500", "130300", "270500", "310400", "170400", "032700", "310300", "311700", "250200", "070600",
                "300200", "121800", "141300", "270200", "160300", "090400", "250600", "081000", "071200", "092300", "121700", "231100", "240400", "300400", "251800", "210500", "101400", "271400", "120800", "102100", "140400", "151200", "260400", "111000", "271200", "191200", "211200",
                "170300", "090500", "171500", "150500", "032300", "032600", "091200", "090300", "220700", "300700", "130200", "091100", "070200", "140200", "110800", "070900", "170600", "090900", "080300", "110900", "251900",
                "091000", "231300", "130500", "171000", "271000", "110600", "251100", "171600", "221300", "220600", "260900", "261000", "260800", "181500", "140900", "160600", "120300", "031900", "271300", "100600", "101600", "250300", "110400", "081200", "300300", "121200",
                "171800", "110700", "101500", "100300", "300500", "030400", "032400", "201100", "171300", "020000", "131200", "031400", "191000", "080500", "040000", "181700", "230200", "180600", "310800", "160200", "290500", "221100", "210900", "240600", "240700", "070300", "072000", "151600", "181200", "220400", "091500", "311500",
                "080800", "121100", "072300", "071800", "071600", "210200", "160500", "050000", "181600", "270600", "231200", "240500", "280700", "200500", "150800", "260600", "311100", "311400", "101200", "100700", "120600", "120500", "200700", "080400", "100500", "251400", "281000", "281200",
                "310200", "070400", "150300", "140700", "290300", "180200", "270700", "311000", "101000", "200200", "091900", "320200", "251500", "281400", "110300", "181400", "181300", "200300", "180500", "190400", "191500", "180900", "170700", "130600", "211100", "171200", "281300", "161100", "160100", "071100", "171100",
                "151400", "102000", "091800", "120400", "071300", "200600", "241100", "240800", "161300", "201200", "070800", "100400", "032800", "210800", "220300", "310500", "090700", "180300", "131000", "081400", "190800", "290200", "130700", "230500", "191300", "200800", "140600", "320900", "250400", "190600", "032900", "210300", "121600", "031700", "110500", "071400", "191400", "160900", "270900", "251300", "031800", "071000", "170200", "030700",
                "290400", "081100", "170800", "030500", "190300", "171400", "091400", "120700", "090800", "260300", "030000", "070000", "080000", "090000", "100000", "110000", "120000", "130000", "140000", "150000", "160000", "170000", "180000", "190000", "200000", "210000",
                "220000", "230000", "240000", "250000", "260000", "270000", "280000", "290000", "300000", "310000", "320000", "330000", "340000", "350000", "360000"
        };

        int pagesize = 1;
        boolean splider = true;
        for (int num = 0; num < 410; num++) {
            while (splider) {

                String url = "https://search.51job.com/list/" + value[num] + ",000000,0000,00,9,99," + city[num] + ",2," + pagesize++ + ".html";
                try {
                    PageRequest pr = new PageRequest();
                    pr.setUrl(url);
                    Document doc = JsoupUtil.load(pr);
                    Elements ess = null;
                    if (doc != null)
                        ess = doc.getElementsByTag("a");
                    for (Element ea : ess) {
                        String urla = UrlUtil.gainurl(ea.attr("abs:href"));
                       // FileUtil.appendMethodB(orgfp + fname + ".txt", urla + "~" + ea.text() + "\n");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }

        }
    }
}