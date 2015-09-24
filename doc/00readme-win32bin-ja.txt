Windows バイナリパッケージ of Julius-4.2
===========================================

このパッケージについて
=======================

これは Julius-4.2 の Windows用実行バイナリ配布パッケージです．
Julius Rev.4.2 の Windows 用実行バイナリおよびライブラリが含まれています．
Windows のコンソールモードで動作します．

動作を試すには，ディクテーションキットなどのJulius実行キットを入手して，
実行バイナリをこのアーカイブのものに差し替えて起動して下さい．
また，最新情報は，Julius の Web ページをご覧ください．

	http://julius.sourceforge.jp/

Julius-4.1.3 以降では Microsoft Visual C++ 2008 でのコンパイルをサポー
トしています．詳しくは，ソースアーカイブ (julius-x.x.x.tar.gz) を別途
ダウンロードして展開し，その中の "msvc/00README.txt" をご覧ください．


実行環境
=========

Windows2000, XP, Vista, 7 で動作します．
マイク入力の認識には，DirectSound がインストールされており，かつ
16bit, 16kHz, モノラルで録音できる環境が必要です．
（認識性能はデバイスの録音品質や個人性に大きく左右されます）

認識用文法の作成など，一部のツールには perl が必要です．cygwin, MinGW
+ MSYS および Active perl での動作を確認しています．

コンパイルは cygwin-1.7.5 で "-mno-cygwin" オプション付きで行われました．


Julius およびツール
====================

実行バイナリは bin/ ディレクトリ以下に収められています．

    [本体]
    julius-*.exe    Julius 実行バイナリ

    [ツール]
    mkbingram.exe   N-gram言語モデルをバイナリ形式に変換する
    mkbinhmm.exe    HTK形式のHMM定義ファイルをバイナリ形式に変換する
    mkbinhmmlist.exe  HMMListファイルをバイナリ形式に変換する
    mkgshmm	    Gaussian Mixture Selection のための GSHMM を作る
    mkss.exe	    スペクトルサブトラクション用のノイズスペクトルを
		    マイク入力から計算・保存する

    [ユーティリティ]
    adinrec.exe	    マイク入力を切り出してファイルに記録する．
    adintool.exe    音声入力フロントエンド（ネットワーク入力用）
    jcontrol.exe    モジュールモード用のサンプルクライアント
    jclient.pl	    モジュールモード用のサンプルクライアント(perl版)
    
    [認識用文法作成ツール]
    mkdfa.pl	        文法コンパイラ
    accept_check.exe    入力文に対する受理/非受理をチェックするツール
    generate.exe        ランダム文生成器 (文法)
    generate-ngram.exe  ランダム文生成器 (N-gram)
    dfa_minimize.exe    DFA最小化ツール
    dfa_determinize.exe DFA決定化ツール
    yomi2voca.pl      ひらがな→音素系列変換

    [認識結果の評価ツール]
    scoring/	    認識結果集計ツール


ドキュメント
=============

Julius の特徴や変更点，最新のオンラインマニュアルについては，
同梱の以下の文書をご覧ください．

    00readme-ja.txt	    この文書
    00readme-julius-ja.txt  Julius-4.2 readme
    LICENSE.txt		    利用許諾
    Release-ja.txt          リリースノートと変更履歴
    Sample.jconf            サンプル jconf ファイル
    manuals-ja/             オンラインマニュアル（日本語）
    manuals/                オンラインマニュアル（英語）


チュートリアルや様々な使用方法，各機能の紹介，認識用文法の書き方，
コンパイルの方法など，様々なドキュメントを Julius の Web ページで
公開していますので，そちらを是非ご一読下さい．

    Julius Webページ：http://julius.sourceforge.jp/


実行キットについて
===================

Julius は単体では動きません．動作させるには言語モデルと音響モデ
ルが必要です．とりあえず動作に必要なものを集めたキットがホームページで
公開されています．詳しくはWebページをご覧下さい．


JuliusLib
==========

rev. 4.0 より認識エンジン本体はライブラリ JuliusLib になりました．
ヘッダが "include" に，スタティックライブラリが "lib" にあります．

"julius-simple" ディレクトリには，JuliusLib を利用するサンプルプログラ
ムが含まれています．これはJuliusの簡易版であり，同じ様式のコマンドオプ
ションに従って音声認識を起動し，認識結果を標準出力に出力します．
mingw や cygwin 環境では以下のコマンドでコンパイルできますので，参考に
してください．

      % cd julius-simple
      % make


プラグインのサンプルコード
===========================

"plugin-sample" には，Julius用プラグイン開発のためのサンプルプログラム
が含まれています（内容はソースアーカイブに含まれているものと同じです）．
"make" でコンパイルできます．詳細は，ディレクトリ内の 00readme-ja.txt
および Juliusbook の11章を参考にしてください．


