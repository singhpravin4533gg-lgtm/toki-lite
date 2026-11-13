import 'dart:math';
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
  final TextEditingController _appIdController =
      TextEditingController(text: '7d9fb3e0517840d38e246fbb98315d22');
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _channelController =
      TextEditingController(text: 'toki_room_1');
  final TextEditingController _nameController =
      TextEditingController(text: 'Pravin');

  final List> _trendingRooms = [
    {'title': '🔥 Desi Adda & Ludo Night', 'channel': 'toki_room_1', 'users': '128 Online'},
    {'title': '🎵 Late Night Lofi & Shayari', 'channel': 'toki_room_1', 'users': '94 Online'},
    {'title': '🏏 Cricket & Masti Club', 'channel': 'toki_room_1', 'users': '76 Online'},
  ];

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
          userName: _nameController.text.trim().isEmpty
              ? 'Host'
              : _nameController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B39EF),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.graphic_eq),
            SizedBox(width: 8),
            Text('Toki Lite', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.monetization_on, size: 16, color: Colors.black87),
                SizedBox(width: 4),
                Text('5,000',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B39EF), Color(0xFF7B61FF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🎙️ Live Audio Rooms & Ludo',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('बात करें, गिफ्ट भेजें और दोस्तों के साथ लूडो खेलें',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'आपका नाम (Display Name)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _appIdController,
              decoration: const InputDecoration(
                labelText: 'Agora App ID (पहले से सेव)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Agora Temp Token पेस्ट करें',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.security),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _channelController,
              decoration: const InputDecoration(
                labelText: 'Room / Channel का नाम',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mic),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B39EF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _openRoom(_channelController.text.trim()),
              icon: const Icon(Icons.headset_mic),
              label: const Text('Live Audio Room जॉइन करें',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            const Text('🔥 Trending Rooms',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._trendingRooms.map(
              (room) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF4B39EF),
                    child: Icon(Icons.mic, color: Colors.white),
                  ),
                  title: Text(room['title']!,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(room['users']!),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B39EF),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _openRoom(room['channel']!),
                    child: const Text('Join'),
                  ),
                ),
              ),
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
  final String userName;

  const LiveRoomPage({
    super.key,
    required this.appId,
    required this.token,
    required this.channelName,
    required this.userName,
  });

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  RtcEngine? _engine;
  bool _joined = false;
  bool _muted = false;
  int _coins = 5000;
  int _mySeat = 0;
  final List<int> _remoteUsers = [];
  final TextEditingController _chatController = TextEditingController();
  final List> _messages = [
    {'sender': 'System', 'text': '🎉 Toki Lite रूम में आपका स्वागत है!'},
  ];

  // Mini Ludo State
  int _diceValue = 6;
  int _currentTurn = 0; // 0: Red, 1: Green, 2: Yellow, 3: Blue
  final List<int> _playerPositions = [0, 0, 0, 0];
  final List<String> _playerNames = ['Red', 'Green', 'Yellow', 'Blue'];
  final List<Color> _playerColors = [
    Colors.redAccent,
    Colors.green,
    Colors.amber,
    Colors.lightBlueAccent,
  ];

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
          setState(() {
            _joined = true;
            _messages.add({
              'sender': 'System',
              'text': '🟢 ${widget.userName} लाइव ऑडियो से जुड़ गए हैं'
            });
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUsers.add(remoteUid);
            _messages.add(
                {'sender': 'System', 'text': '👋 User $remoteUid रूम में आए'});
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            _remoteUsers.remove(remoteUid);
          });
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

  void _sendMessage([String? quickText]) {
    final text = (quickText ?? _chatController.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'sender': widget.userName, 'text': text});
      if (quickText == null) _chatController.clear();
    });
  }

  void _openGiftSheet() {
    final gifts = [
      {'icon': '🌹', 'name': 'Rose', 'cost': 10},
      {'icon': '💖', 'name': 'Heart', 'cost': 50},
      {'icon': '👑', 'name': 'Crown', 'cost': 200},
      {'icon': '🚀', 'name': 'Rocket', 'cost': 500},
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1B3A),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('🎁 Send Gift',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('🪙 Coins: $_coins',
                    style: const TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: gifts.map((g) {
                return GestureDetector(
                  onTap: () {
                    final cost = g['cost'] as int;
                    if (_coins >= cost) {
                      setState(() {
                        _coins -= cost;
                        _messages.add({
                          'sender': widget.userName,
                          'text': 'ने ${g['icon']} ${g['name']} गिफ्ट भेजा!'
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(g['icon'] as String,
                            style: const TextStyle(fontSize: 30)),
                        const SizedBox(height: 4),
                        Text(g['name'] as String,
                            style: const TextStyle(color: Colors.white)),
                        Text('🪙 ${g['cost']}',
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _openLudoGameSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1F1B3A),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          void rollDice() {
            final rolled = Random().nextInt(6) + 1;
            setModalState(() {
              _diceValue = rolled;
              _playerPositions[_currentTurn] =
                  (_playerPositions[_currentTurn] + rolled).clamp(0, 56);
              if (_playerPositions[_currentTurn] >= 56) {
                _messages.add({
                  'sender': '🎮 Ludo',
                  'text': '🏆 ${_playerNames[_currentTurn]} जीत गया!'
                });
              }
              _currentTurn = (_currentTurn + 1) % 4;
            });
            setState(() {});
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('🎲 Toki Ludo Club',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                // Ludo Board Visual
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              _ludoHomeBox('RED', Colors.redAccent,
                                  _playerPositions[0]),
                              _ludoTrackBox('Track'),
                              _ludoHomeBox(
                                  'GREEN', Colors.green, _playerPositions[1]),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _ludoTrackBox('Left'),
                              Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  gradient: const SweepGradient(colors: [
                                    Colors.redAccent,
                                    Colors.green,
                                    Colors.amber,
                                    Colors.blue,
                                    Colors.redAccent
                                  ]),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text('HOME\n🏆',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              _ludoTrackBox('Right'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _ludoHomeBox('BLUE', Colors.lightBlue,
                                  _playerPositions[3]),
                              _ludoTrackBox('Bottom'),
                              _ludoHomeBox(
                                  'YELLOW', Colors.amber, _playerPositions[2]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _playerColors[_currentTurn],
                          radius: 10,
                        ),
                        const SizedBox(width: 8),
                        Text('बारी: ${_playerNames[_currentTurn]}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B39EF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: rollDice,
                      icon: const Icon(Icons.casino),
                      label: Text('Dice फेंकें ($_diceValue)',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _ludoHomeBox(String title, Color color, int steps) {
    return Expanded(
      child: Co
