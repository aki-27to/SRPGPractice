extends Node

## このスクリプトは、ゲーム内で「ステージ（レベル）」を読み込む役割を持つサンプルスクリプトです。
## 実際のゲームでは、ここを改造してステージを切り替えたり、再読み込みをしたりします。

#region: --- フィールド（プロパティ） ---

## level_instance は、「今ロードされているステージ(TacticsLevel)」を入れておくための変数です。
## 例えば「草原ステージ」や「砂漠ステージ」といったシーンを実体化したものが、この変数に保管されます。
var level_instance: TacticsLevel

## world は、3Dシーンの大元（ルート）となるノードへの参照です。
## ステージ（マップ）などをこのノードに追加していくことで、画面上に表示されるようになります。
@onready var world: Node3D = $World

## demo_map_button は、サンプルとして用意した「マップを読み込むボタン」です。
## このボタンが押されると、あらかじめ設定したマップをロードします。
@onready var demo_map_button: Button = $UI/MapSelector/LoadMap0

#endregion


#region: --- 初期処理 ---

## _ready() 関数は、スクリプトがシーンツリーに追加された瞬間に一度だけ呼ばれる関数です。
## ここでは、demo_map_button をフォーカス状態にする（キーボードで操作可能にする）処理を行っています。
func _ready() -> void:
	demo_map_button.grab_focus()

#endregion


#region: --- シグナル ---

## _on_load_map_0_pressed() 関数は、demo_map_button が押された時に自動的に呼び出される関数です。
## ボタンのシグナル機能を使うと、こういった「ボタンが押されたら○○する」という処理を書けます。
func _on_load_map_0_pressed() -> void:
	# ここでは "test" という名前のステージ（ファイル）をロードするようにしています。
	load_level("test")

#endregion


#region: --- メソッド ---

## unload_level() は「今読み込んでいるステージ(TacticsLevel)を削除する」処理をまとめています。
## is_instance_valid(level_instance) で、まだステージが存在しているか確認し、
## 存在する場合は queue_free() でステージをシーンツリーから削除してメモリを開放します。
## その後、level_instance を null にすることで「もう何も読み込まれていない」状態を表します。
func unload_level() -> void:
	if is_instance_valid(level_instance):
		level_instance.queue_free()
	level_instance = null

## load_level(level_name: String) は「新しいステージを読み込んで表示する」ための処理です。
## 引数 level_name で指定した名前から、実際のシーンファイル（.tscn）へのパスを作り、
## それを load() して instantiate() することで新しいステージノードを作ります。
## 作ったステージノードは world に add_child() することで、ゲーム内に表示されるようになります。
## 最後に、マップセレクタUIを非表示にすることで、マップ選択画面が隠れてゲーム画面だけを見せるようにします。
func load_level(level_name: String) -> void:
	# 既に読み込んでいたステージがあれば削除しておく
	unload_level()

	# level_name からシーンファイルのパスを組み立てる
	var level_path: String = "res://assets/maps/level/%s_level.tscn" % level_name

	# シーンファイルをロードしてインスタンス化（実際のノードに）する
	level_instance = load(level_path).instantiate()

	# world にステージを追加すると、ゲーム画面に表示される
	world.add_child(level_instance)

	# マップセレクタを非表示にして、ゲーム画面をスッキリ見せる
	$UI/MapSelector.visible = false

#endregion
