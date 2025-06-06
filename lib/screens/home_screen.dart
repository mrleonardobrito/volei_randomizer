import 'package:flutter/material.dart';
import 'package:volei_randomizer/screens/players_screen.dart';
import 'package:volei_randomizer/screens/teams_screen.dart';
import 'package:volei_randomizer/screens/matches_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vôlei Randomizer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sports_volleyball,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 32),
            const Text(
              'Gerencie seus times de vôlei',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildMenuCard(
              context,
              icon: Icons.person_add,
              title: 'Gerenciar Jogadores',
              subtitle: 'Adicione titulares e reservas',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlayersScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              icon: Icons.group,
              title: 'Gerenciar Times',
              subtitle: 'Visualize e organize os times',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeamsScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              icon: Icons.sports,
              title: 'Partidas e Chaveamento',
              subtitle: 'Organize as partidas e definir vencedores',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MatchesScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
