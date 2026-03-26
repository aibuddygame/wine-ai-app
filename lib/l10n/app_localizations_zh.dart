// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Wine AI';

  @override
  String get tabContext => '設定';

  @override
  String get tabScan => '掃描';

  @override
  String get tabVault => '酒窖';

  @override
  String get contextTitle => '您的設定';

  @override
  String get contextSubtitle => '幫助我們為您的商務晚餐定制葡萄酒推薦';

  @override
  String get occupationLabel => '您的職業 / 行業';

  @override
  String get occupationHint => '例如：ESG顧問、投資銀行';

  @override
  String get budgetLabel => '典型酒瓶預算（港元）';

  @override
  String get saveContextButton => '保存設定';

  @override
  String get editContext => '編輯設定';

  @override
  String get cancel => '取消';

  @override
  String get scannerTitle => '掃描葡萄酒';

  @override
  String get scannerSubtitle => '拍攝葡萄酒標籤或菜單';

  @override
  String get captureButton => '拍攝';

  @override
  String get galleryButton => '從相冊選擇';

  @override
  String get analyzingLabel => '分析中...';

  @override
  String get analyzingSubtitle => '我們的人工智能侍酒師正在分析您的葡萄酒';

  @override
  String get positionLabel => '將葡萄酒標籤\n置於框內';

  @override
  String get apiKeyWarning => 'API 密鑰未配置。請設置 KIMI_API_KEY 以啟用掃描功能。';

  @override
  String get resultsTitle => '葡萄酒分析';

  @override
  String get regionStyle => '產區與風格';

  @override
  String get priceBenchmarks => '價格與評比';

  @override
  String get averagePrice => '平均價格';

  @override
  String get globalRanking => '全球排名';

  @override
  String get regionalRanking => '產區排名';

  @override
  String topPercent(int percent, String scope) {
    return '$scope前$percent%';
  }

  @override
  String get tasteProfile => '口感特徵';

  @override
  String get body => '酒體';

  @override
  String get tannin => '丹寧';

  @override
  String get sweetness => '甜度';

  @override
  String get acidity => '酸度';

  @override
  String get light => '輕盈';

  @override
  String get bold => '濃郁';

  @override
  String get smooth => '柔順';

  @override
  String get tannic => '澀口';

  @override
  String get dry => '乾型';

  @override
  String get sweet => '甜型';

  @override
  String get soft => '柔和';

  @override
  String get acidic => '酸爽';

  @override
  String get flavors => '風味';

  @override
  String get primary => '一級香氣';

  @override
  String get secondary => '二級香氣';

  @override
  String get tertiary => '三級香氣（陳年）';

  @override
  String get communityMentions => '社區提及';

  @override
  String get socialScripts => '社交腳本';

  @override
  String get theHook => '開場白';

  @override
  String get theObservation => '觀察點';

  @override
  String get theQuestion => '提問';

  @override
  String get serving => '侍酒建議';

  @override
  String get temperature => '溫度';

  @override
  String get decanting => '醒酒';

  @override
  String get glass => '酒杯';

  @override
  String get proTip => '專業提示';

  @override
  String get grapes => '葡萄品種';

  @override
  String get aboutGrapes => '關於葡萄品種';

  @override
  String get pairing => '配餐建議';

  @override
  String get matchScore => '配對評分';

  @override
  String get goesWellWith => '適合搭配：';

  @override
  String get avoid => '避免';

  @override
  String get ranking => '排名';

  @override
  String get world => '全球';

  @override
  String get community => '社區';

  @override
  String get reviews => '評論';

  @override
  String get ratings => '個評分';

  @override
  String get saveToVault => '加入酒窖';

  @override
  String get faceEarned => '獲得面子';

  @override
  String get points => '分';

  @override
  String get saved => '已保存到酒窖！';

  @override
  String get vaultTitle => '您的酒窖';

  @override
  String get vaultSubtitle => '您的葡萄酒之旅與成就';

  @override
  String get totalFaceEarned => '總面子積分';

  @override
  String get totalScannedValue => '總掃描價值';

  @override
  String get winesScanned => '已掃描葡萄酒';

  @override
  String get yourTier => '您的等級';

  @override
  String get favoriteCuisine => '最愛菜系';

  @override
  String get scanHistory => '掃描記錄';

  @override
  String get refresh => '重新整理';

  @override
  String get emptyVault => '尚末掃描任何葡萄酒。開始建立您的酒窖吧！';

  @override
  String get startScanning => '開始掃描';

  @override
  String get climate => '氣候';

  @override
  String get profile => '特徵';

  @override
  String get language => '語言';

  @override
  String get english => 'English';

  @override
  String get traditionalChinese => '繁體中文';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appName => 'Wine AI';

  @override
  String get tabContext => '設定';

  @override
  String get tabScan => '掃描';

  @override
  String get tabVault => '酒窖';

  @override
  String get contextTitle => '您的設定';

  @override
  String get contextSubtitle => '幫助我們為您的商務晚餐定制葡萄酒推薦';

  @override
  String get occupationLabel => '您的職業 / 行業';

  @override
  String get occupationHint => '例如：ESG顧問、投資銀行';

  @override
  String get budgetLabel => '典型酒瓶預算（港元）';

  @override
  String get saveContextButton => '保存設定';

  @override
  String get editContext => '編輯設定';

  @override
  String get cancel => '取消';

  @override
  String get scannerTitle => '掃描葡萄酒';

  @override
  String get scannerSubtitle => '拍攝葡萄酒標籤或菜單';

  @override
  String get captureButton => '拍攝';

  @override
  String get galleryButton => '從相冊選擇';

  @override
  String get analyzingLabel => '分析中...';

  @override
  String get analyzingSubtitle => '我們的人工智能侍酒師正在分析您的葡萄酒';

  @override
  String get positionLabel => '將葡萄酒標籤\n置於框內';

  @override
  String get apiKeyWarning => 'API 密鑰未配置。請設置 KIMI_API_KEY 以啟用掃描功能。';

  @override
  String get resultsTitle => '葡萄酒分析';

  @override
  String get regionStyle => '產區與風格';

  @override
  String get priceBenchmarks => '價格與評比';

  @override
  String get averagePrice => '平均價格';

  @override
  String get globalRanking => '全球排名';

  @override
  String get regionalRanking => '產區排名';

  @override
  String topPercent(int percent, String scope) {
    return '$scope前$percent%';
  }

  @override
  String get tasteProfile => '口感特徵';

  @override
  String get body => '酒體';

  @override
  String get tannin => '丹寧';

  @override
  String get sweetness => '甜度';

  @override
  String get acidity => '酸度';

  @override
  String get light => '輕盈';

  @override
  String get bold => '濃郁';

  @override
  String get smooth => '柔順';

  @override
  String get tannic => '澀口';

  @override
  String get dry => '乾型';

  @override
  String get sweet => '甜型';

  @override
  String get soft => '柔和';

  @override
  String get acidic => '酸爽';

  @override
  String get flavors => '風味';

  @override
  String get primary => '一級香氣';

  @override
  String get secondary => '二級香氣';

  @override
  String get tertiary => '三級香氣（陳年）';

  @override
  String get communityMentions => '社區提及';

  @override
  String get socialScripts => '社交腳本';

  @override
  String get theHook => '開場白';

  @override
  String get theObservation => '觀察點';

  @override
  String get theQuestion => '提問';

  @override
  String get serving => '侍酒建議';

  @override
  String get temperature => '溫度';

  @override
  String get decanting => '醒酒';

  @override
  String get glass => '酒杯';

  @override
  String get proTip => '專業提示';

  @override
  String get grapes => '葡萄品種';

  @override
  String get aboutGrapes => '關於葡萄品種';

  @override
  String get pairing => '配餐建議';

  @override
  String get matchScore => '配對評分';

  @override
  String get goesWellWith => '適合搭配：';

  @override
  String get avoid => '避免';

  @override
  String get ranking => '排名';

  @override
  String get world => '全球';

  @override
  String get community => '社區';

  @override
  String get reviews => '評論';

  @override
  String get ratings => '個評分';

  @override
  String get saveToVault => '加入酒窖';

  @override
  String get faceEarned => '獲得面子';

  @override
  String get points => '分';

  @override
  String get saved => '已保存到酒窖！';

  @override
  String get vaultTitle => '您的酒窖';

  @override
  String get vaultSubtitle => '您的葡萄酒之旅與成就';

  @override
  String get totalFaceEarned => '總面子積分';

  @override
  String get totalScannedValue => '總掃描價值';

  @override
  String get winesScanned => '已掃描葡萄酒';

  @override
  String get yourTier => '您的等級';

  @override
  String get favoriteCuisine => '最愛菜系';

  @override
  String get scanHistory => '掃描記錄';

  @override
  String get refresh => '重新整理';

  @override
  String get emptyVault => '尚末掃描任何葡萄酒。開始建立您的酒窖吧！';

  @override
  String get startScanning => '開始掃描';

  @override
  String get climate => '氣候';

  @override
  String get profile => '特徵';

  @override
  String get language => '語言';

  @override
  String get english => 'English';

  @override
  String get traditionalChinese => '繁體中文';
}
