using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Threading;

namespace YunShu.RCmd
{
	public class MainClass
	{
		private static string VERSON = "RCmd 1.00 Build01";
		private static int MaxThread;

		public static int Main(string[] args)
		{
			if (args.Length != 6)
			{
				Console.WriteLine("\nRun cmd via ssh channel, Code by yunshu, {0}", VERSON);
				Console.WriteLine("This code is under BSD, You can change it by yourself.\n");
				Console.WriteLine("Usage: RCmd <HostList> <MaxThread> <UserName> <PassWord> <Cmd> <TimeOut>");
				Console.WriteLine("Example: RCmd f:\\IP.txt 20 yunshu test_pass \"ps aux\" 8");

				return -1;
			}

			ArrayList HostList = LoadHostList(args[0]);
			if (HostList == null)
			{
				return -1;
			}

			MaxThread = int.Parse(args[1]);
			ArrayList WorkThreadPool = new ArrayList(MaxThread);
			SshUtil MyUtil;
			RCmd MyCmd;
			int TimeOut= int.Parse(args[5]) * 1000;

			// 遍历机器列表
			foreach (string Host in HostList)
			{
				// 如果当前线程数量超过了最大线程数量
				while (WorkThreadPool.Count >= MaxThread)
				{
					ThreadControl.CleanThread(WorkThreadPool, TimeOut);
					Thread.Sleep(500);
				}

				MyUtil = new SshUtil(Host, args[2], args[3], args[4]);
				MyCmd = new RCmd(MyUtil);

				Thread WorkThread = new Thread(new ThreadStart(MyCmd.ExecCmd));

				WorkThread.IsBackground = true;
				WorkThread.Start();

				WorkThreadPool.Add(new ThreadInfo(WorkThread, 0));

				Thread.Sleep(500);
			}

			while (WorkThreadPool.Count > 0)
			{
				ThreadControl.CleanThread(WorkThreadPool, TimeOut);
				Thread.Sleep(1000);
			}

			Console.WriteLine("All done!");
			Environment.Exit(0);

			return 0;
		}

		/// <summary>
		/// 打开机器列表文件，读取机器名到ArrayList
		/// </summary>
		/// <param name="FilePath">文件路径</param>
		/// <returns>ArrayList保存的机器列表</returns>
		private static ArrayList LoadHostList(string FilePath)
		{
			StreamReader reader = null;
			ArrayList HostList = new ArrayList( );

			try
			{
				reader = File.OpenText( FilePath );
				String Host = null;

				while ((Host = reader.ReadLine()) != null)
				{
					HostList.Add(Host);
				}
			}
			catch (Exception e)
			{
				Console.WriteLine("Open host list error: " + e.Message.ToString());
			}
			
			reader.Close();
			return HostList;
		}
	}
}
