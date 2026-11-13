import 'dart:async';
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

  String _selectedAvatar = '😎';
  int _coins = 10000;
  int _vipLevel = 1;

  final List<String> _avatars = ['😎', '👑', '🦁', '🔥', '🎧', '💎'];

  final List> _trendingRooms = [
    {
      'title': '🔥 Desi Adda & Ludo Night',
      'channel': 'toki_room_1',
      'users': '142 Online',
      'tag': 'Party'
    },
    {
      'title': '🎵 Late Night Lofi & Shayari',
      'channel': 'toki_room_1',
      'users': '98 Online',
      'tag': 'Music'
    },
    {
      'title': '🏏 Cricket & Masti Club',
      'channel': 'toki_room_1',
      'users': '84 Online',
      'tag': 'Sports'
    },
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
          userAvatar: _selectedAvatar,
          initialCoins: _coins,
          initialVip: _vipLevel,
          onStatsUpdated: (newCoins, newVip) {
            setState(() {
              _coins = newCoins;
              _vipLevel = newVip;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2FF),
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
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade900,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber),
            ),
            child: Text('VIP $_vipLevel',
                style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on,
                    size: 16, color: Colors.black87),
                const SizedBox(width: 4),
                Text('$_coins',
                    style: const TextStyle(
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B39EF), Color(0xFF7B61FF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('👤 अपनी प्रोफ़ाइल और अवतार चुनें',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _avatars.map((av) {
                      final selected = av == _selectedAvatar;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedAvatar = av),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              selected ? Colors.amber : Colors.white24,
                          child: Text(av, style: const TextStyle(fontSize: 22)),
                        ),
                      );
                    }).toList(),
                  ),
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
              label: const Text('Live Party Room शुरू करें',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 18),
            const Text('🔥 Trending Party Rooms',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._trendingRooms.map(
              (room) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF4B39EF),
                    child: Icon(Icons.graphic_eq, color: Colors.white),
                  ),
                  title: Text(room['title']!,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${room['tag']} • ${room['users']}'),
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
  final String userAvatar;
  final int initialCoins;
  final int initialVip;
  final Function(int coins, int vip) onStatsUpdated;

  const LiveRoomPage({
    super.key,
    required this.appId,
    required this.token,
    required this.channelName,
    required this.userName,
    required this.userAvatar,
    required this.initialCoins,
    required this.initialVip,
    required this.onStatsUpdated,
  });

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  RtcEngine? _engine;
  bool _joined = false;
  bool _muted = false;
  bool _following = false;
  late int _coins;
  late int _vipLevel;
  int _totalGifted = 0;

  int _mySeat = 0;
  final Set<int> _lockedSeats = {};
  final List<int> _remoteUsers = [];

  int _themeIndex = 0;
  final List<List<Color>> _roomThemes = [
    [const Color(0xFF1A143B), const Color(0xFF2D1E6B)],
    [const Color(0xFF0D1B2A), const Color(0xFF1B263B)],
    [const Color(0xFF2B1226), const Color(0xFF591C3E)],
    [const Color(0xFF1F1A0D), const Color(0xFF4A3810)],
  ];

  String? _activeGiftBanner;
  String? _floatingEmoji;

  final Map<String, int> _gifters = {
    'Aarav 👑': 450,
    'Riya 💎': 300,
  };

  final TextEditingController _chatController = TextEditingController();
  final List> _messages = [
    {'sender': 'System', 'text': '🎉 Toki Lite पार्टी रूम में आपका स्वागत है!'},
  ];

  int _diceValue = 6;
  int _currentTurn = 0;
  final List<int> _playerPositions = [0, 0, 0, 0];
  final List<String> _playerNames = ['Red', 'Green', 'Yellow', 'Blue'];
  final List<Color> _playerColors = [
    Colors.redAccent,
    Colors.green,
    Colors.amber,
    Colors.lightBlueAccent,
  ];

  final List<String> _truthDareList = [
    '🎤 Truth: अपना सबसे पसंदीदा गाना 2 लाइन गाकर सुनाएँ!',
    '🔥 Dare: रूम में बैठे किसी दोस्त की तारीफ़ में शायरी बोलें!',
    '😂 Truth: बचपन की सबसे मज़ेदार शरारत बताएं!',
    '👑 Dare: अगले 2 मिनट तक राजा/रानी की आवाज़ में बात करें!',
    '🎁 Dare: अपने पसंदीदा दोस्त को एक गुलाब (🌹) गिफ्ट भेजें!',
  ];
  String _currentTruthDare = 'स्पिन दबाकर सवाल या चैलेंज पाएं!';

  @override
  void initState() {
    super.initState();
    _coins = widget.initialCoins;
    _vipLevel = widget.initialVip;
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

  void _triggerEmoji(String emoji) {
    setState(() {
      _floatingEmoji = emoji;
      _messages.add({'sender': widget.userName, 'text': emoji});
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _floatingEmoji = null);
    });
  }

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'sender': '[VIP $_vipLevel] ${widget.userName}',
        'text': text
      });
      _chatController.clear();
    });
  }

  void _handleSeatTap(int seatIndex) {
    if (_lockedSeats.contains(seatIndex)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔒 यह सीट लॉक है!')),
      );
      return;
    }
    setState(() {
      _mySeat = seatIndex;
    });
  }

  void _handleSeatLongPress(int seatIndex) {
    if (seatIndex == 0) return;
    setState(() {
      if (_lockedSeats.contains(seatIndex)) {
        _lockedSeats.remove(seatIndex);
      } else {
        _lockedSeats.add(seatIndex);
      }
    });
  }

  void _openLeaderboardSheet() {
    final sorted = _gifters.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1B3A),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆 Top Gifters Ranking',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...sorted.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final item = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: rank == 1 ? Colors.amber : Colors.white24,
                  child: Text('#$rank',
                      style: TextStyle(
                          color: rank == 1 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                title: Text(item.key,
                    style: const TextStyle(color: Colors.white)),
                trailing: Text('🪙 ${item.value}',
                    style: const TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold)),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openGiftSheet() {
    final gifts = [
      {'icon': '🌹', 'name': 'Rose', 'cost': 10},
      {'icon': '💖', 'name': 'Heart', 'cost': 50},
      {'icon': '👑', 'name': 'Crown', 'cost': 200},
      {'icon': '🏎️', 'name': 'Supercar', 'cost': 500},
      {'icon': '🚀', 'name': 'Rocket', 'cost': 1000},
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
                const Text('🎁 Send Luxury Gift',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('🪙 $_coins | VIP $_vipLevel',
                    style: const TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: gifts.map((g) {
                  return GestureDetector(
                    onTap: () {
                      final cost = g['cost'] as int;
                      if (_coins >= cost) {
                        setState(() {
                          _coins -= cost;
                          _totalGifted += cost;
                          _vipLevel = (_totalGifted ~/ 300) + 1;
                          final myKey = '${widget.userName} ${widget.userAvatar}';
                          _gifters[myKey] = (_gifters[myKey] ?? 0) + cost;
                          _activeGiftBanner =
                              '${widget.userName} ने ${g['icon']} ${g['name']} भेजा!';
                          _messages.add({
                            'sender': '🎁 Gift',
                            'text': _activeGiftBanner!,
                          });
                        });
                        widget.onStatsUpdated(_coins, _vipLevel);
                        Navigator.pop(context);
                        Timer(const Duration(seconds: 3), () {
                          if (mounted) {
                            setState(() => _activeGiftBanner = null);
                          }
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
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
            ),
            const SizedBox(height: 10),
          ],        
