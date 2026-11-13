import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const TokiLiteApp());
}

class TokiLiteApp extends StatelessWidget {
  const TokiLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toki Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4B39EF)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _appIdController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _channelController =
      TextEditingController(text: 'toki_room_1');

  void _openRoom(String roomName) {
    final appId = _appIdController.text.trim();
    if (appId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया पहले अपनी Agora App ID डालें!')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LiveRoomPage(
          appId: appId,
          token: _tokenController.text.trim(),
          channelName: roomName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B39EF),
        foregroundColor: Colors.white,
        title: const Text('Toki Lite',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4B39EF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Voice Chat Rooms',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('दोस्तों के साथ लाइव ऑडियो रूम में जुड़ें और बात करें',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _appIdController,
              decoration: const InputDecoration(
                labelText: 'Agora App ID डालें',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Agora Temp Token डालें',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.security),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _channelController,
              decoration: const InputDecoration(
                labelText: 'Room / Channel का नाम',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mic),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B39EF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => _openRoom(_channelController.text.trim()),
              icon: const Icon(Icons.headset_mic),
              label: const Text('Live Audio Room जॉइन करें',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveRoomPage extends StatefulWidget {
  final String appId;
  final String token;
  final String channelName;

  const LiveRoomPage({
    super.key,
    required this.appId,
    required this.token,
    required this.channelName,
  });

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  RtcEngine? _engine;
  bool _joined = false;
  bool _muted = false;
  final List<int> _remoteUsers = [];

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await [Permission.microphone].request();
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: widget.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() => _joined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() => _remoteUsers.add(remoteUid));
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() => _remoteUsers.remove(remoteUid));
        },
      ),
    );

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableAudio();
    await _engine!.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> _toggleMute() async {
    setState(() => _muted = !_muted);
    await _engine?.muteLocalAudioStream(_muted);
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSeats = [0, ..._remoteUsers];

    return Scaffold(
      backgroundColor: const Color(0xFF16132B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B39EF),
        foregroundColor: Colors.white,
        title: Text('Room: ${widget.channelName}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              _joined ? '🟢 लाइव ऑडियो कनेक्टेड' : '🟡 रूम से जुड़ रहे हैं...',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                final hasUser = index < activeSeats.length;
                final label = index == 0
                    ? 'आप (Host)'
                    : hasUser
                        ? 'User ${activeSeats[index]}'
                        : 'Seat ${index + 1}';
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: hasUser
                          ? const Color(0xFF4B39EF)
                          : Colors.white12,
                      child: Icon(
                        hasUser ? Icons.mic : Icons.chair_alt,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'mute',
                  backgroundColor:
                      _muted ? Colors.redAccent : const Color(0xFF4B39EF),
                  onPressed: _toggleMute,
                  child: Icon(_muted ? Icons.mic_off : Icons.mic,
                      color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'leave',
                  backgroundColor: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
