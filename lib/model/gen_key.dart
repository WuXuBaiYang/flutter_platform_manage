/*
* android签名生成参数
* @author wuxubaiyang
* @Time 2022/11/14 11:34
*/
class AndroidKeyGenParams {
  // 别名
  final String alias;

  // 签名方式
  final String keyAlg;

  // 签名长度
  final int keySize;

  // 有效期(单位为天)
  final int validity;

  // 签名信息
  final AndroidKeyGenDName dName;

  // 签名密码
  final String keyPass;

  // 文件密码
  final String storePass;

  // 签名存储路径
  final String keystore;

  AndroidKeyGenParams({
    required this.alias,
    required this.validity,
    required this.dName,
    required this.keyPass,
    required this.storePass,
    required this.keystore,
    this.keyAlg = 'RSA',
    this.keySize = 2048,
  });

  AndroidKeyGenParams.info({
    required this.storePass,
    required this.keystore,
  })  : alias = '',
        keyAlg = '',
        keySize = 0,
        validity = 0,
        dName = AndroidKeyGenDName.empty(),
        keyPass = '';

  // 判断参数是否满足获取签名信息的需求
  bool checkCanGetInfo() => storePass.isNotEmpty && keystore.isNotEmpty;

  // 判断参数是否满足生成签名的需求
  bool checkCanGenKey() =>
      alias.isNotEmpty &&
      keyAlg.isNotEmpty &&
      keySize > 0 &&
      validity > 0 &&
      keyPass.isNotEmpty &&
      storePass.isNotEmpty &&
      keystore.isNotEmpty;

  // 获取dName的信息字符串
  String getDNameInfo() =>
      'CN=${dName.cn},OU=${dName.ou},O=${dName.o},L=${dName.l},S=${dName.s},C=${dName.c}';
}

/*
* android签名生成-企业信息
* @author wuxubaiyang
* @Time 2022/11/14 11:38
*/
class AndroidKeyGenDName {
  // 名字
  final String cn;

  // 组织单位名称
  final String ou;

  // 组织名称
  final String o;

  // 所在城市
  final String l;

  // 所在省份
  final String s;

  // 所在国家
  final String c;

  AndroidKeyGenDName({
    required this.cn,
    required this.ou,
    required this.o,
    required this.l,
    required this.s,
    required this.c,
  });

  AndroidKeyGenDName.empty()
      : cn = '',
        ou = '',
        o = '',
        l = '',
        s = '',
        c = '';
}
