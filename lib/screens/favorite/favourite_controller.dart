import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:defino/database/dbhelper.dart';
import 'package:defino/model/db_model.dart';
import 'package:defino/model/words_model.dart';
import 'package:defino/model/wordsdb_model.dart';

class FavoriteController extends GetxController {
  Dbhelper _dbhelper=Dbhelper();
  final favWords = <SaveWordsModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   if( _dbhelper.getAllWords().isNotEmpty){
    favWords.addAll(_dbhelper.getAllWords());
    print("your fav words count is ---> ${favWords.length}");
  
    }
   }
  //  favWords.value=_dbhelper.getAllWords();
    // favWords.addAll(_)
  }
// }
