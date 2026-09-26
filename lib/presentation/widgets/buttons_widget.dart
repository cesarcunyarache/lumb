import 'package:flutter/material.dart';

class ButtonsWidget extends StatelessWidget {
  final bool timerStarted;
  final Function() start;
  final Function() stop;
  final Function() restart;

  const ButtonsWidget({
    super.key,
    required this.timerStarted,
    required this.start,
    required this.stop,
    required this.restart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón de Start
        TransparentCard(
          child: SizedBox(
            height: 50,
            width: 150,
            child: GestureDetector(
               onTap: timerStarted ? null : start,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                ),
               Text(
                  'Iniciar',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                
      ],
               
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),


TransparentCard(
          child: SizedBox(
            height: 50,
            width: 150,
            child: GestureDetector(
               onTap: !timerStarted ? null : stop,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 30,
                ),
               Text(
                  'Pausa',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                
      ],
               
              ),
            ),
          ),
        ),
        
        // Botón de Pause
       
        /* const SizedBox(width: 20),

        // Botón de Restart
        TransparentCard(
          child: SizedBox(
            height: 50,
            width: 150,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.restart_alt_outlined,
                color: Colors.white,
                size: 30,
              ),
              label: const Text(
                'Restart',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.6),
                shape: const StadiumBorder(),
              ),
              onPressed: restart,
            ),
          ),
        ), */
      ],
    );
  }
}

// Implementación de TransparentCard
class TransparentCard extends StatelessWidget {
  final Widget child;
  
  const TransparentCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}