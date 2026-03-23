import 'package:flutter/material.dart';

class FiumicelloLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const FiumicelloLoadingIndicator({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  State<FiumicelloLoadingIndicator> createState() => _FiumicelloLoadingIndicatorState();
}

class _FiumicelloLoadingIndicatorState extends State<FiumicelloLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duración de la animación de llenado
    )..repeat(); // Repetir infinitamente

    // La animación va de 0.0 (vacío) a 1.0 (lleno)
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Sombrero de fondo (opaco/transparente o en escala de grises si se desea)
              Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/fiumicello_hat.png',
                  width: widget.size,
                  height: widget.size,
                  color: widget.color ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
              // Sombrero que se va "llenando" desde abajo hacia arriba
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: _animation.value, // Esto corta la imagen desde arriba
                    child: Image.asset(
                      'assets/images/fiumicello_hat.png',
                      width: widget.size,
                      height: widget.size,
                      color: widget.color,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
