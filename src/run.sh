#!/usr/bin/env bash
#---------------------------------------------------------------------------
# NewsApiを使ってみる。
# CreatedAt: 2019-09-16
#---------------------------------------------------------------------------
get_news_api_key() { cat "${HOME}/root/work/record/pc/account/newsapikey"; }
request() {
	NEWS_API_KEY="${NEWS_API_KEY:-"`get_news_api_key`"}"
	curl https://newsapi.org/v2/top-headlines -G \
	 -d country=jp \
	 -d pageSize=100 \
	 -H "X-Api-Key:${NEWS_API_KEY}"
}
# $1: NewsApi結果JSONファイルパス
is_run() {
	[ ! -f "${1}" ] && echo 'true' || is_not_today "${1}";
}
# $1: NewsApi結果JSONファイルパス
is_not_today() {
	# ファイルが存在し、更新日時が今日なら falseを返す
	updated="`date +"%Y-%m-%d" -r "${1}"`"
	[ "$updated" = "`date +"%Y-%m-%d"`" ] && echo 'false' || echo 'true';
}
run() {
	local TODAY_NEWS="${TODAY_NEWS:-TodayNews.json}"
	[ 'false' = "`is_run "${TODAY_NEWS}"`" ] && exit 1;
	echo "`request`" > "${TODAY_NEWS}"
	cat "${TODAY_NEWS}"
}
run

