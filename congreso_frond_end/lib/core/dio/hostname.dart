import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Hostname {
  static String urlBaseProd = "login.flexpdv.app";
  static String apiProd = "/comercial/api";
  static int portaProd = 8444;

  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------NO MODIFICAR ESTE ARCHIVO-----------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------

  static String httpURL() {
    if (kReleaseMode) {
      return "https://$urlBaseProd:${portaProd.toString()}$apiProd";
      // return "${dotenv.env['urlBaseDev']}:${dotenv.env['portaDev']}${dotenv.env['apiDev']}";
    } else {
      // return "https://$urlBaseProd:${portaProd.toString()}$apiProd";
      return "${dotenv.env['urlBaseDev']}:${dotenv.env['portaDev']}${dotenv.env['apiDev']}";
    }
  }

  static String httpURLSocket() {
    String ip = '';
    kReleaseMode
        // ? ip =
        //     "${dotenv.env['urlBaseDev']}:${dotenv.env['portaDev']}${dotenv.env['apiDev']}"
        ? ip = "wss://$urlBaseProd:${portaProd.toString()}/comercial/ws"
        : ip = "${dotenv.env['urlSocketDev']}:${dotenv.env['portaDev']}/ws";

    //'ws://192.168.0.216:8081/ws'
    return ip;
  }

  // static String httpImageURL(String path) {
  //   final supabase = Supabase.instance.client;
  //   final url = supabase.storage.from('comercial_sas').getPublicUrl(path);
  //   return url;
  // }
}
