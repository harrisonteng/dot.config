using System;
using System.Diagnostics;
using System.Threading;

public class TestThread
{
	public static void Main( )
	{
		Thread Work = new Thread( new ThreadStart(Test) );
		Work.IsBackground=true;
		Work.Start();

		//while(true)
		//{
			Console.WriteLine(Process.GetCurrentProcess().Threads.Count);
			Thread.Sleep( 1000 );
		//}
	}

	public static void Test( )
	{
		while( true )
		{
			Console.WriteLine( "hello" );
			Thread.Sleep( 1000 );
		}
	}
}