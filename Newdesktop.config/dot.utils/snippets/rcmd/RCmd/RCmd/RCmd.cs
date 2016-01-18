using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

using Tamir.SharpSsh;
using Tamir.Streams;

namespace YunShu.RCmd
{
	public class RCmd
	{
		private SshUtil _SshConnInfo;

		public RCmd(SshUtil MyInfo)
		{
			this._SshConnInfo = MyInfo;
		}

		/// <summary>
		/// 在远程主机执行一条命令
		/// </summary>
		/// <param name="SshConnInfo">SSH连接信息，包含主机名，用户名，密码，以及要执行的命令语句</param>
		public void ExecCmd( )
		{
			string Response;
			SshUtil SshConnInfo = this._SshConnInfo;

			try
			{
				if (SshConnInfo.Host.Trim() == "")
				{
					return;
				}
			
				SshExec Exec = new SshExec(SshConnInfo.Host, SshConnInfo.UserName, SshConnInfo.PassWord);
				//Console.WriteLine("Process {0} ....", SshConnInfo.Host);

				try
				{
					Exec.Connect();
				}
				catch (Exception)
				{
					//Console.WriteLine("Connect {0} error...", SshConnInfo.Host);
					return;
				}

				try
				{
					Response = Exec.RunCommand(SshConnInfo.Cmd);
					if (Response.Trim() != "")
					{
						Console.WriteLine("{0}\n{1}", SshConnInfo.Host, Response);
					}
					else
					{
						return;
					}
				}
				catch (Exception)
				{
					//Console.WriteLine("Run cmd on  {0} error...", SshConnInfo.Host);
					return;
				}

				Exec.Close();
			}

			catch (ThreadAbortException)
			{
				//Console.WriteLine("Process {0} time out...", SshConnInfo.Host);
				return;
			}

			catch (Exception)
			{
				//Console.WriteLine("Process {0} error...", SshConnInfo.Host);
				return;
			}
		}
	}
}
