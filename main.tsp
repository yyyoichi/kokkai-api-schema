import "@typespec/http";
import "@typespec/openapi3";
using Http;
@service(#{ title: "【非公式】国会会議録検索システム　検索用API", version: "1.0.0" })
@server("https://kokkai.ndl.go.jp", "国会会議録検索システム 検索用APIのエンドポイント")
namespace Kokkai;

@doc("院名")
enum NameOfHouse {
  Shugi: "衆議院";
  Sangi: "参議院";
  Both: "両院";
  BothConference: "両院協議会";
}

@doc("検索対象箇所")
enum SearchRange {
  Head: "冒頭";
  Body: "本文";
  HeadAndBody: "冒頭・本文";
}

@doc("発言者役割")
enum SpeakerRole {
  Witness: "証人";
  Adviser: "参考人";
  Declarant: "公述人";
}

@doc("イメージ種別")
enum ImageKind {
  Record: "会議録";
  Toc: "目次";
  Index: "索引";
  Appendix: "附録";
  Supplement: "追録";
}

model SearchParams {
  @query
  @doc("検索結果の開始位置を指定します。省略時は1が指定されたものとして検索します。")
  startRecord?: int32;
  @query
  @doc("返戻件数の最大数を指定します。（会議単位簡易出力・発言単位出力:1～100、会議単位出力:1～10）。省略時はデフォルト件数で返戻します。")
  maximumRecords?: int32;
  @query
  @doc("検索対象の院名を指定します。省略可。")
  nameOfHouse?: NameOfHouse;
  @query
  @doc("検索対象の会議名を部分一致で指定します。複数語はスペース区切りでOR検索になります。省略可。")
  nameOfMeeting?: string;
  @query
  @doc("発言部分を検索対象とするキーワードを指定します。複数語はスペース区切りでAND検索になります。省略可。")
  any?: string;
  @query
  @doc("発言者名を部分一致で指定します。複数語はスペース区切りでOR検索になります。省略可。")
  speaker?: string;
  @query
  @doc("開催日付の範囲開始日をYYYY-MM-DD形式で指定します。省略可。")
  from?: string;
  @query
  @doc("開催日付の範囲終了日をYYYY-MM-DD形式で指定します。省略可。")
  until?: string;
  @query
  @doc("追録・附録を検索対象に限定するかを指定します。省略時はfalse（限定しない）となります。")
  supplementAndAppendix?: boolean;
  @query
  @doc("目次・索引を検索対象に限定するかを指定します。省略時はfalse（限定しない）となります。")
  contentsAndIndex?: boolean;
  @query
  @doc("検索対象箇所を指定します。\"冒頭\",\"本文\",\"冒頭・本文\"のいずれかを指定可能です。省略時は\"冒頭・本文\"となります。")
  searchRange?: SearchRange;
  @query
  @doc("閉会中の会議録を限定検索するかを指定します。省略時はfalse（限定しない）となります。")
  closing?: boolean;
  @query
  @doc("発言番号を整数で指定します。完全一致検索。省略可。")
  speechNumber?: int32;
  @query
  @doc("発言者肩書きを部分一致で指定します。省略可。")
  speakerPosition?: string;
  @query
  @doc("発言者所属会派を部分一致で指定します。省略可。")
  speakerGroup?: string;
  @query
  @doc("発言者役割を指定します。\"証人\",\"参考人\",\"公述人\"のいずれかを指定可能です。省略可。")
  speakerRole?: SpeakerRole;
  @query
  @doc("発言IDを\"issueID_発言番号\"形式で指定します。完全一致検索。省略可。")
  speechID?: string;
  @query
  @doc("会議録IDを21桁の英数字で指定します。完全一致検索。省略可。")
  issueID?: string;
  @query
  @doc("国会回次の開始回を指定します。省略可。")
  sessionFrom?: int32;
  @query
  @doc("国会回次の終了回を指定します。省略可。")
  sessionTo?: int32;
  @query
  @doc("号数の開始号を指定します。省略可。")
  issueFrom?: int32;
  @query
  @doc("号数の終了号を指定します。省略可。")
  issueTo?: int32;
  @query
  @doc("応答形式を指定します。'xml'または'json'。省略時は'json'となります。")
  recordPacking?: "json" | "xml" = "json";
}

model MeetingListSpeechRecord {
  @doc("発言ID。\"issueID_発言番号\"形式。")
  speechID: string;
  @doc("発言順序。")
  speechOrder: int32;
  @doc("発言者名。")
  speaker: "会議録情報" | string;
  @doc("発言テキストへのURL。")
  speechURL: string;
}


model MeetingSpeechRecord {
  @doc("発言ID。\"issueID_発言番号\"形式。")
  speechID: string;
  @doc("発言順序。")
  speechOrder: int32;
  @doc("発言者名。")
  speaker: "会議録情報" | string;
  @doc("発言者名の読み仮名。")
  speakerYomi: string | null;
  @doc("発言者の所属会派。")
  speakerGroup: string | null;
  @doc("発言者の肩書き。")
  speakerPosition: string | null;
  @doc("発言者の役割。")
  speakerRole: SpeakerRole | null;
  @doc("発言内容。")
  speech: string;
  @doc("発言が開始されるページ番号。")
  startPage: int32;
  @doc("レコード作成日時 (YYYY-MM-DD HH:mm:ss)。")
  createTime: string;
  @doc("レコード更新日時 (YYYY-MM-DD HH:mm:ss)。")
  updateTime: string;
  @doc("発言テキストへのURL。")
  speechURL: string;
}

model SpeechRecord {
  @doc("発言ID。\"issueID_発言番号\"形式。")
  speechID: string;
  @doc("会議録ID。")
  issueID: string;
  @doc("資料種別。")
  imageKind: ImageKind;
  @doc("検索対象箇所。")
  searchObject: int32;
  @doc("国会回次。")
  session: int32;
  @doc("院名。")
  nameOfHouse: NameOfHouse;
  @doc("会議名。")
  nameOfMeeting: string;
  @doc("号数。\"第issue号\"形式。")
  issue: string;
  @doc("開催日付 (YYYY-MM-DD)。")
  date: string;
  @doc("閉会中フラグ。nullの場合あり。")
  closing: boolean | null;
  @doc("発言順序。")
  speechOrder: int32;
  @doc("発言者名。")
  speaker: "会議録情報" | string;
  @doc("発言者名の読み仮名。nullの場合あり。")
  speakerYomi: string | null;
  @doc("発言者の所属会派。nullの場合あり。")
  speakerGroup: string | null;
  @doc("発言者の肩書き。nullの場合あり。")
  speakerPosition: string | null;
  @doc("発言者の役割。nullの場合あり。")
  speakerRole: SpeakerRole | null;
  @doc("発言内容。")
  speech: string;
  @doc("発言が開始されるページ番号。")
  startPage: int32;
  @doc("発言テキストへのURL。")
  speechURL: string;
  @doc("会議録テキスト表示画面へのURL。")
  meetingURL: string;
  @doc("会議録PDF表示画面へのURL。nullの場合あり。")
  pdfURL: string | null;
}

model MeetingRecord<SpeechRecordSchema = MeetingListSpeechRecord | MeetingSpeechRecord> {
  @doc("発言ID。\"issueID_発言番号\"形式。")
  issueID: string;
  @doc("資料種別。")
  imageKind: ImageKind;
  @doc("検索対象箇所。")
  searchObject: int32;
  @doc("国会回次。")
  session: int32;
  @doc("院名。")
  nameOfHouse: NameOfHouse;
  @doc("会議名。")
  nameOfMeeting: string;
  @doc("号数。\"第issue号\"形式。")
  issue: string;
  @doc("開催日付 (YYYY-MM-DD)。")
  date: string;
  @doc("閉会中フラグ。")
  closing: boolean | null;
  @doc("発言リスト。")
  speechRecord: SpeechRecordSchema[];
  @doc("会議録テキスト表示画面へのURL。")
  meetingURL: string;
  @doc("会議録PDF表示画面へのURL。")
  pdfURL: string | null;
}

model MeetingListResponse {
  @doc("総結果件数")
  numberOfRecords: int32;
  @doc("返戻件数")
  numberOfReturn: int32;
  @doc("開始位置")
  startRecord: int32;
  @doc("次開始位置")
  nextRecordPosition: int32 | null;
  meetingRecord: MeetingRecord<MeetingListSpeechRecord>[];
}

model MeetingResponse {
  @doc("総結果件数")
  numberOfRecords: int32;
  @doc("返戻件数")
  numberOfReturn: int32;
  @doc("開始位置")
  startRecord: int32;
  @doc("次開始位置")
  nextRecordPosition: int32 | null;
  meetingRecord: MeetingRecord<MeetingSpeechRecord>[];
}

model SpeechResponse {
  @doc("総結果件数")
  numberOfRecords: int32;
  @doc("返戻件数")
  numberOfReturn: int32;
  @doc("開始位置")
  startRecord: int32;
  @doc("次開始位置")
  nextRecordPosition: int32 | null;
  speechRecord: SpeechRecord[];
}

model ErrorResponse {
  message: string;
  details?: string[];
}

@route("/api")
interface Api {
  @route("/meeting_list") @get meetingList(...SearchParams): MeetingListResponse;
  @route("/meeting") @get meeting(...SearchParams): MeetingResponse;
  @route("/speech") @get speech(...SearchParams): SpeechResponse;
}