using System;
using System.Collections.Generic;
using System.Text;

using Tamir.Streams;
using Tamir.SharpSsh;

namespace YunShu.RCmd
{
	public class SshUtil
	{
		public string Host;
		public string UserName;
		public string PassWord;
		public string Cmd;

		public SshUtil(string _Host, string _UserName, string _PassWord, string _Cmd)
		{
			this.Host = _Host;
			this.UserName = _UserName;
			this.PassWord = _PassWord;
			this.Cmd = _Cmd;
		}
	}
}
