using System;
using System.Collections.Generic;
using System.Linq;
using FastTests;
using Raven.Client.Documents;
using Raven.Client.ServerWide;
using Raven.Client.ServerWide.Operations;
using SlowTests.Graph;

namespace Tryouts
{
    public static class Program
    {
        class NotExists
        {
            public string Name;
        }
        public static void Main(string[] args)
        {
            using (var store = new DocumentStore
            {
                Urls = new[] {"http://127.0.0.1:8080"},
                Database = "Stackoverflow"
            })
            {
                store.Initialize();
                if (args.Length != 1)
                {
                    Console.WriteLine("Usage: Util < --create-databases | --non-stale > ");
                    Environment.Exit(1);
                }

                if (args[0].Equals("--create-databases"))
                {
                    try
                    {
                        store.Maintenance.Server.Send(new CreateDatabaseOperation(new DatabaseRecord("BenchmarkDB")));
                        store.Maintenance.Server.Send(new CreateDatabaseOperation(new DatabaseRecord("Stackoverflow")));
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Problems with database creation");
                        Console.WriteLine(e.Message);
                        Environment.Exit(1);
                    }
                }
                else if (args[0].Equals("--non-stale"))
                {
                    using (var session = store.OpenSession("Stackoverflow"))
                    {
                        RavenTestBase.WaitForIndexing(store, timeout: TimeSpan.FromDays(1));
                    }
                }
                else
                {
                    Console.WriteLine("Usage: Util < --create-databases | --non-stale > ");
                    Environment.Exit(1);
                }
            }
        }
    }
}
