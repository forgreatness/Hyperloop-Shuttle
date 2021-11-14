using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ContainerInterface;
using System.Diagnostics;

namespace GameInstance
{
    class Game : GameInterface
    {
        GameState StateOfGame;
        bool LDown = false;
        bool RDown = false;
        int Score = 0;
        int SurvivorPositionTop = 430;
        int SurvivorPositionLeft = 300;
        int SurvivorPositionBottom = 450;
        int SurvivorPositionRight = 400;
        const int BarrierHeight = 30;
        const int EscapeMargin = 30;
        List<double[]> Barriers = new List<double[]>();

        enum GameState
        {
            InGame,
            GameOver
        }

        public Game()
        {
            Debug.Print("Game created.");
            StateOfGame = GameState.InGame;
            GenerateBarrier();
        }

        public void Reset()
        {
            Debug.Print("Reset");
            StateOfGame = GameState.InGame;
            Barriers.Clear();
            Score = 0;
            GenerateBarrier();
        }

        //Generate 4 barriers at the start of game
        public void GenerateBarrier()
        {
            Random rand = new Random();

            double barrierEscapePosition = rand.Next(0, Convert.ToInt32(GameRendering.RenderWidth - (SurvivorPositionRight - SurvivorPositionLeft + EscapeMargin)));
            Barriers.Add(new double[] { 50, barrierEscapePosition });

            for (int i = 0; i < 3; i++)
            {
                barrierEscapePosition = rand.Next(0, Convert.ToInt32(GameRendering.RenderWidth - (SurvivorPositionRight - SurvivorPositionLeft + EscapeMargin)));
                Barriers.Add(new double[] { Barriers.ElementAt(i)[0] + 100, barrierEscapePosition });
            }
        }

        public void Update(GameUpdate update_info)
        {
            if (StateOfGame == GameState.InGame)
            {
                LDown = update_info.GetKeyState(GameKeys.Left);
                RDown = update_info.GetKeyState(GameKeys.Right);

                if (LDown)
                {
                    if (SurvivorPositionLeft > 0)
                    {
                        SurvivorPositionLeft -= 5;
                        SurvivorPositionRight -= 5;
                    }
                }

                if (RDown)
                {
                    if (SurvivorPositionRight < GameRendering.RenderWidth)
                    {
                        SurvivorPositionLeft += 5;
                        SurvivorPositionRight += 5;
                    }
                }

                //Move the Barrier
                foreach (double[] barrier in Barriers)
                {
                    barrier[0] += 1;
                }

                //Check if the user is past the last barrier
                if (Barriers.Last()[0] > SurvivorPositionBottom)
                {
                    Score++;

                    //Remove the Barrier and intilize a new one to the front of barriers
                    Barriers.RemoveAt(Barriers.Count - 1);
                    Random rand = new Random();

                    double barrierEscapePosition = rand.Next(0, Convert.ToInt32(GameRendering.RenderWidth - (SurvivorPositionRight - SurvivorPositionLeft + EscapeMargin)));
                    Barriers.Insert(0, new double[] { 50, barrierEscapePosition });
                }

                //Check if the user collides with last barrier. 
                //We know the survivor can collide with barrier when the bottom of the barrier position is within the top of the survivor position
                if (Barriers.Last()[0] + BarrierHeight > SurvivorPositionTop && Barriers.Last()[0] < SurvivorPositionBottom)
                {
                    //But they actually dont collide yet until the left of the survivor position is less than the start the escape position
                    //OR: the right of the survivor position is greater than the end of the escape
                    if (SurvivorPositionLeft < Barriers.Last()[1] || SurvivorPositionRight > (SurvivorPositionRight - SurvivorPositionLeft + EscapeMargin + Barriers.Last()[1]))
                    {
                        //If they collide set the state of the game to GameOver
                        StateOfGame = GameState.GameOver;
                    }
                }
            }
        }

        int RenderCount = 0;
        const int BeepPeriod = 60;

        public void Render(GameRendering renderer)
        {
            //Drawing the boxscore
            renderer.DrawRect(RenderColors.White, 0, 640, 40, 0);
            renderer.DrawText(280, 10, $"Score: {Score}");
            renderer.DrawRect(RenderColors.Black, 49, 640, 50, 0);

            if (StateOfGame == GameState.InGame)
            {
                if ((RenderCount++ % BeepPeriod) == 0)
                    renderer.PlaySound(GameSounds.SoundBeep);

                //Drawing the survivor
                renderer.DrawRect(LDown ? RenderColors.Blue : RenderColors.Red,
                    SurvivorPositionTop, SurvivorPositionLeft, SurvivorPositionBottom, SurvivorPositionRight);

                foreach (double[] barrier in Barriers)
                {
                    renderer.DrawRect(RenderColors.Black, barrier[0], 0, BarrierHeight + barrier[0], barrier[1]);
                    renderer.DrawRect(RenderColors.Black, barrier[0], barrier[1] + (SurvivorPositionRight - SurvivorPositionLeft + EscapeMargin), BarrierHeight + barrier[0], GameRendering.RenderWidth);
                }
            } else
            {
                renderer.DrawText(250, 250, "Game Over.");
            }
        }
    };
}
