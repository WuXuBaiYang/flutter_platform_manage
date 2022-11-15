/*
* android签名生成参数
* @author wuxubaiyang
* @Time 2022/11/14 11:34
*/
class AndroidKeyParams {
  // 别名
  String alias = '';

  // 签名方式
  String keyAlg = 'RSA';

  // 签名长度
  int keySize = 2048;

  // 有效期(单位为天)
  int validity = 0;

  // 签名信息
  final dName = AndroidKeyDName();

  // 签名密码
  String keyPass = '';

  // 文件密码
  String storePass = '';

  // 签名存储路径
  String keystore = '';

  AndroidKeyParams();

  AndroidKeyParams.info({
    required this.storePass,
    required this.keystore,
  });

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
  String getDNameInfo() => 'CN=${dName?.cn ?? ''},OU=${dName?.ou ?? ''},'
      'O=${dName?.o ?? ''},L=${dName?.l ?? ''},'
      'S=${dName?.s ?? ''},C=${dName?.c ?? ''}';
}

/*
* android签名生成-企业信息
* @author wuxubaiyang
* @Time 2022/11/14 11:38
*/
class AndroidKeyDName {
  // 名字
  String cn = '';

  // 组织单位名称
  String ou = '';

  // 组织名称
  String o = '';

  // 所在城市
  String l = '';

  // 所在省份
  String s = '';

  // 所在国家
  String c = '';
}
