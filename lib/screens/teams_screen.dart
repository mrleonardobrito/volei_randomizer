import 'package:flutter/material.dart';
import 'package:volei_randomizer/models/player.dart';
import 'package:volei_randomizer/models/team.dart';
import 'package:volei_randomizer/services/volleyball_service.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final VolleyballService _service = VolleyballService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    setState(() {});
  }

  void _regenerateTeams() {
    if (!_service.canCreateTeams()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('É necessário pelo menos 6 titulares para formar times'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Regenerar Times'),
        content: const Text(
          'Tem certeza que deseja regenerar os times aleatoriamente? '
          'Isso irá reorganizar todos os jogadores e limpar substituições.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _service.regenerateTeams();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Times regenerados com sucesso!')),
              );
            },
            child: const Text('Regenerar'),
          ),
        ],
      ),
    );
  }

  void _showSubstitutionDialog(Player titular) {
    final availableReservas = _service.reservas;

    if (availableReservas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há reservas disponíveis')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Substituir ${titular.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Escolha um reserva para substituir este jogador:'),
            const SizedBox(height: 16),
            ...availableReservas.map((reserva) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      reserva.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(reserva.name),
                  onTap: () {
                    _service.substitutePlayer(titular.id, reserva.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${titular.name} foi substituído por ${reserva.name}'),
                      ),
                    );
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _revertSubstitution(String originalTitularId) {
    final originalTitular =
        _service.allPlayers.firstWhere((p) => p.id == originalTitularId);
    final substituteId = _service.playerSubstitutions[originalTitularId];
    final substitute =
        _service.allPlayers.firstWhere((p) => p.id == substituteId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reverter Substituição'),
        content: Text(
          'Deseja reverter a substituição e colocar ${originalTitular.name} '
          'de volta no lugar de ${substitute.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _service.revertSubstitution(originalTitularId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${originalTitular.name} voltou ao time'),
                ),
              );
            },
            child: const Text('Reverter'),
          ),
        ],
      ),
    );
  }

  void _handlePlayerTap(
      Player player, bool isSubstituted, bool isOriginalTitular) {
    if (isOriginalTitular || isSubstituted) {
      final titularId = isOriginalTitular
          ? _service.playerSubstitutions.entries
              .firstWhere((entry) => entry.value == player.id)
              .key
          : player.id;

      _revertSubstitution(titularId);
      return;
    }

    if (player.type == PlayerType.titular) {
      _showSubstitutionDialog(player);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final teams = _service.teams;
    final reservas = _service.reservas;
    final canCreateTeams = _service.canCreateTeams();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Times'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: canCreateTeams ? _regenerateTeams : null,
            tooltip: 'Regenerar times',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard(
                      'Times Formados',
                      '${teams.length}',
                      Icons.group,
                      Colors.blue,
                    ),
                    _buildInfoCard(
                      'Jogadores em Times',
                      '${_service.totalPlayersInTeams}',
                      Icons.person,
                      Colors.green,
                    ),
                    _buildInfoCard(
                      'Reservas',
                      '${reservas.length}',
                      Icons.person_outline,
                      Colors.orange,
                    ),
                  ],
                ),
                if (!canCreateTeams) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.amber),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'É necessário pelo menos 6 titulares para formar times',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: teams.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      return _buildTeamCard(teams[index]);
                    },
                  ),
          ),
          if (reservas.isNotEmpty)
            Container(
              width: double.infinity,
              color: Colors.orange[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.people_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'Reservas Disponíveis (${reservas.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: reservas.length,
                      itemBuilder: (context, index) {
                        final reserva = reservas[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Text(
                                reserva.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            label: Text(reserva.name),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum time formado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Adicione pelo menos 6 titulares para formar times automaticamente',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(Team team) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.group,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  team.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text('${team.players.length}/${team.maxPlayers}'),
                  backgroundColor:
                      team.isFull ? Colors.green[100] : Colors.orange[100],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: team.players.map((player) {
                final isSubstituted =
                    _service.playerSubstitutions.containsKey(player.id);
                final isOriginalTitular =
                    _service.playerSubstitutions.values.contains(player.id);

                return GestureDetector(
                  onTap: () => _handlePlayerTap(
                      player, isSubstituted, isOriginalTitular),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSubstituted
                          ? Colors.red[100]
                          : isOriginalTitular
                              ? Colors.green[100]
                              : player.type == PlayerType.titular
                                  ? Colors.blue[100]
                                  : Colors.orange[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSubstituted
                            ? Colors.red
                            : isOriginalTitular
                                ? Colors.green
                                : player.type == PlayerType.titular
                                    ? Colors.blue
                                    : Colors.orange,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSubstituted
                              ? Icons.swap_horiz
                              : isOriginalTitular
                                  ? Icons.change_circle
                                  : player.type == PlayerType.titular
                                      ? Icons.star
                                      : Icons.person_outline,
                          size: 16,
                          color: isSubstituted
                              ? Colors.red
                              : isOriginalTitular
                                  ? Colors.green
                                  : player.type == PlayerType.titular
                                      ? Colors.blue
                                      : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          player.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSubstituted
                                ? Colors.red[700]
                                : isOriginalTitular
                                    ? Colors.green[700]
                                    : player.type == PlayerType.titular
                                        ? Colors.blue[700]
                                        : Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
