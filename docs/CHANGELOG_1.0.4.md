# AgentAtelierR 1.0.4 正式版

Android / Windows 版本：`1.0.4+43`。GitHub 标签：`v1.0.4`。2026-10-13 覆盖更新同一正式版 Release 的 Android APK 与 Windows ZIP。

## 本次更新

- 修复长期记忆混入角色台词、`[happy]` / `[emphasis]` 等表演标签及半截句子的问题。标签不作为情绪证据，日文“喜欢书”等背景介绍不误判为关系转折，本地事实注明人物归属并保留完整句子；无效或过长的新候选整批拒绝，不跳过尚未整理的内容。
- 最近／长期模型摘要按界面语言整理，要求第三方客观概览。“马上整理”支持重新整理旧本地条目、读取对应原始对话及补齐缺失译文；没有原文时只概括现存片段，确认后才保存。
- 修复手动整理失败时最近记忆和进度部分保存，以及确认后仍显示旧译文的问题。手改摘要标记为手动来源；长期记忆、最近记忆与检查点一次性提交，记忆卡片显示来源并允许补写译文。
- 虚拟手机按照实际可用屏幕自适应，左右与底部铺满，顶部保留安全区域；内容避让设备边缘和系统导航区域。
- 两端由同一份 Flutter 源码重新构建，保持公开版本 `1.0.4`，内部构建号递增至 `43`。记忆修复与操作方式见 [长期记忆修复说明](https://github.com/onion-aqua/AgentAtelierR/blob/v1.0.4/docs/MEMORY_FIX_2026-10-13.md)。

## 此前已完成的更新

- 修复场景 NPC 同意交换联系方式后没有添加确认的问题。识别自然联系请求和当前 NPC 的明确同意，兼容卡菈实际台词「よかろう」及「構わん」「いいじゃろう」等古风日语。明确的换渠道短句可承接紧邻的完整回复；仍由用户点击“加入信息”确认，拒绝、旁白、译文、转述及过期邀请不会自动添加联系人。
- 统一中英日角色名称映射：`fee / Fee / Fi / 菲 / フィー` 保存为 `fee`，`卡菈 / 卡拉 / Kala / カラ / カラ・イデアス` 保存为 `kala`。角色查询、发言解析、头像显示、语言校正、联系请求和聊天记忆使用同一身份；较长名字覆盖短名字，避免把“菲”匹配进“菲德丽卡”“洁菲娜”“苏菲”。两位普拉芙妲与莱莎／苏菲的角色域保持隔离。
- 日志页面增加卡片间距，修复分类遗漏和分类后不显示；分类条数随当前级别同步，过滤器默认折叠，保留更多正文空间，切换条件时重置滚动并清楚显示空结果。
- 统一检查并修复小屏、大字体、键盘避让、异步返回和液态玻璃显示：PC Agent 输入与确认区域、闹钟时间选择、任务、炼金和地图布局适应可用空间；设置嵌入手机时避免双返回按钮，浅色玻璃标题栏保持可读。
- 手动记忆整理保留请求期间的用户草稿，最近记忆列表实时刷新；音色克隆取消后不更新已销毁页面，数据转换只关闭自己的进度路由，PC Agent 晚到响应不污染新会话。历史搜索自动展开命中存档，ASMR 语言与收藏主题随设置更新，并清理转场动画监听器。
- 闹钟添加防重复提交，失败时反馈并清理，按最终确认时刻计算下次响铃。Windows 尚无对应原生闹钟支持，页面明确说明并避免调用缺失接口。

更新后如果旧包漏掉联系人确认，请在当前对话里重新询问一次交换联系方式；不会从旧历史自动添加。详情见 [NPC 联系请求与名称映射修复](https://github.com/onion-aqua/AgentAtelierR/blob/v1.0.4/docs/bugfix_npc_contact_followup.md) 和 [页面统一检查记录](https://github.com/onion-aqua/AgentAtelierR/blob/v1.0.4/docs/UI_AUDIT_2026-10-12.md)。

## 保留的近期更新

- 弱上下文兼容模式保留长期记忆的当前状态、关键条目与最近事实；整理失败按批次冷却。LLM 缓存诊断在服务商未返回缓存字段时标记为 `unknown`，避免误报缓存未命中。
- 普通语音、持续 ASMR 与试音支持可选立体声和居中／偏左／偏右的固定声音位置；原生立体声保留原有声场。持续 ASMR 入队前检查音频包络与时长，损坏音频重新合成一次；Android 音源准备失败时用相同字节备用加载一次，避免重复请求 TTS。
- Windows Fish Audio 直连不可达时使用已启用的系统 HTTP 代理或 HTTP 代理环境配置，保留 HTTPS 校验。代理软件需运行；目前不解析 PAC/WPAD，不支持 SOCKS 或带账号密码的代理地址。
- 动作规划按意图、身体区域、动作族、姿态和轨道分层召回，并参考角色状态、情绪及最近动作；缺失准确动作时保持 `none/unsupported`。两端保留加密内置服装 `crf_skn_002_0006_01`（东方旗袍·紫色）。
- 保留近期／长期记忆分层整理、追加式记忆账本、虚拟手机、NPC 信息和 PC Agent 联动。

## 构建与产物

两端均使用正常 `main` 入口及项目受保护脚本，启用角色资源加密、私有联动配置保护、Dart 混淆和分离调试符号：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tool\build_protected.ps1 -Target apk -Mode release
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tool\build_protected.ps1 -Target windows -Mode release
```

| 附件 | 大小（字节） | SHA-256 |
| --- | ---: | --- |
| `AgentAtelierR-1.0.4-release.apk` | 646,074,816 | `4b125ca16ac91a6d01bc8fa27b93959677bf4f1bd63697988cf04f6a261dc4aa` |
| `AgentAtelierR-1.0.4-windows-release.zip` | 598,532,988 | `9a92e69f6d7fe30010b5532fabc2a952728a61c817a380a83b9bc8d1fd33711f` |

本地产物分别位于 `build/app/outputs/flutter-apk/app-release.apk` 和 `build/releases/AgentAtelierR-1.0.4-windows-release-final.zip`。Android 元数据为 `versionName=1.0.4`、`versionCode=43`，APK v2 签名验证通过；Windows EXE 文件与产品版本均为 `1.0.4+43`，`IsDebug=false`。两端归档 CRC 校验通过，均包含 7 个加密角色包与 7 个加密预览，包头为 `AARENCR1`，没有服装 0006 原始文件或独立密钥文件。Windows ZIP 包含完整运行目录，包括 EXE、DLL 与 `data/app.so`。

Android APK 继续使用现有调试签名，以便覆盖安装测试包，不代表应用商店签名。原始服装、苏菲立绘、独立加密角色包、密钥与私有服务器配置不提交源码仓库。

## 验证结果与范围

- 本轮全量 Flutter 测试：1204 项通过、15 项既有跳过；另补充冒号偏好记录的回归验证，Flutter 静态分析无问题。跳过项不能解释为通过。
- 19 项真实 `ChatScreen` 回环集成测试经过发送、语言校正、NPC 确认、存档保存与虚拟手机联系人窗口，覆盖设备读取的卡菈台词、菲三语言流程及“菲德丽卡不应带入菲”。模型服务使用本机测试回复，Spine 使用加载占位；未将其视为新版真机在线聊天或动画验收。
- 此前模拟器实际巡检主聊天、虚拟手机主页及 16 个功能页面，确认返回、浅色玻璃标题栏和单返回按钮。该巡检使用 `+41` 加密 debug 包，完整记录见页面检查文档。
- 此前 ASMR 原生音频诊断在 Android 模拟器完成 59 项检查，含 40 段单声道自然播放后的连续切换，0 项失败。手机 Fish Audio 的实际 `what:13` 场景、耳机听感、Windows 在线语音与后台真实推送仍需要实际运行验证。
- 本次发布未操作手机；长期记忆实际模型整理、音色效果和 Windows 外部服务尚未重新运行验证。未修改 dshagalt 项目或服务器部署，未向真实 PC Agent 自动下发任务；构建成功不代表上述效果已验收。

音频说明见 [立体声与固定位置](https://github.com/onion-aqua/AgentAtelierR/blob/v1.0.4/docs/tts_stereo.md) 和 [ASMR 音频可靠性](https://github.com/onion-aqua/AgentAtelierR/blob/v1.0.4/docs/asmr_audio_reliability.md)；代理使用见 [NPC 与 Fish Audio 代理修复](https://github.com/onion-aqua/AgentAtelierR/blob/v1.0.4/docs/bugfix_npc_fish_proxy.md)。

## PC 版使用

解压 Release 附件 `AgentAtelierR-1.0.4-windows-release.zip` 后运行 `AgentAtelierR.exe`，保留同目录全部 DLL 与 `data` 文件夹。本轮 Windows 版同步上述 Android 共享代码修改，使用 `1.0.4+43` release 构建；应用 Dart 代码位于 `data/app.so`。请勿只复制 EXE。
