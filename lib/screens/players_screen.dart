import 'package:flutter/material.dart';
import 'package:volei_randomizer/models/player.dart';
import 'package:volei_randomizer/services/volleyball_service.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final VolleyballService _service = VolleyballService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bulkController = TextEditingController();
  PlayerType _selectedType = PlayerType.titular;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _nameController.dispose();
    _bulkController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    setState(() {});
  }

  void _addPlayer() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite o nome do jogador')),
      );
      return;
    }

    try {
      if (_service.allPlayers.length >= 18) {
        _service.addPlayer(name, PlayerType.reserva);
      } else {
        _service.addPlayer(name, _selectedType);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    _nameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$name foi adicionado como ${_selectedType == PlayerType.titular ? 'titular' : 'reserva'}',
        ),
      ),
    );
  }

  void _addPlayersFromList() {
    final bulkText = _bulkController.text.trim();
    if (bulkText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira a lista de jogadores')),
      );
      return;
    }

    final lines = bulkText.split('\n');
    for (var line in lines) {
      final parts = line.split('-');
      if (parts.length == 2) {
        final name = parts[1].trim();
        if (name.isNotEmpty) {
          try {
            if (_service.allPlayers.length >= 18) {
              _service.addPlayer(name, PlayerType.reserva);
            } else {
              _service.addPlayer(name, PlayerType.titular);
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Por favor, insira a lista de jogadores no formato 1- Nome')),
        );
      }
    }

    _bulkController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jogadores adicionados com sucesso!')),
    );
  }

  void _removePlayer(Player player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Remoção'),
        content: Text('Tem certeza que deseja remover ${player.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _service.removePlayer(player.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${player.name} foi removido')),
              );
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titulares = _service.titulares;
    final reservas = _service.reservas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Jogadores'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _service.allPlayers.isNotEmpty
                ? () => _showClearAllDialog()
                : null,
            tooltip: 'Limpar todos',
          ),
        ],
      ),
      body: Column(
        children: [
          // Add player form
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do jogador',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        onSubmitted: (_) => _addPlayer(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<PlayerType>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Tipo',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: PlayerType.titular,
                            child: Text('Titular'),
                          ),
                          DropdownMenuItem(
                            value: PlayerType.reserva,
                            child: Text('Reserva'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addPlayer,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Jogador'),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bulkController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Lista de Jogadores (1- Nome)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addPlayersFromList,
                    icon: const Icon(Icons.group_add),
                    label: const Text('Adicionar Lista de Jogadores'),
                  ),
                ),
              ],
            ),
          ),

          // Players list
          Expanded(
            child: ListView(
              children: [
                // Titulares section
                if (titulares.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.green[50],
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Titulares (${titulares.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...titulares.map((player) => _buildPlayerTile(player)),
                ],

                // Reservas section
                if (reservas.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.orange[50],
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'Reservas (${reservas.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...reservas.map((player) => _buildPlayerTile(player)),
                ],

                // Empty state
                if (titulares.isEmpty && reservas.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum jogador cadastrado',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Adicione jogadores usando o formulário acima',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerTile(Player player) {
    final isSubstituted = _service.playerSubstitutions.containsKey(player.id);
    final substituteId = _service.playerSubstitutions[player.id];
    Player? substitute;

    if (substituteId != null) {
      substitute = _service.allPlayers.firstWhere((p) => p.id == substituteId);
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            player.type == PlayerType.titular ? Colors.green : Colors.orange,
        child: Text(
          player.name.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(player.name),
      subtitle: isSubstituted && substitute != null
          ? Text('Substituído por ${substitute.name}')
          : Text(player.type == PlayerType.titular ? 'Titular' : 'Reserva'),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _removePlayer(player),
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Todos os Jogadores'),
        content: const Text(
          'Tem certeza que deseja remover todos os jogadores? '
          'Esta ação também removerá todos os times e partidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _service.clearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todos os dados foram limpos')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
