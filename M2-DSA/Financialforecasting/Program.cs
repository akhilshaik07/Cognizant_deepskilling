using System;
using System.Collections.Generic;

namespace FinancialForecasting
{
    public class FinancialForecast
    {
        // Simple Recursive: O(n) time, O(n) stack space
        public static double FutureValueRecursive(double presentValue, double growthRate, int periods)
        {
            if (periods == 0)
                return presentValue;

            return FutureValueRecursive(presentValue * (1 + growthRate), growthRate, periods - 1);
        }

        // Memoized Recursive: O(n) time, O(n) memo space — avoids recomputation
        private static Dictionary<int, double> _memo = new Dictionary<int, double>();

        public static double FutureValueMemoized(double presentValue, double growthRate, int periods)
        {
            if (periods == 0)
                return presentValue;

            if (_memo.ContainsKey(periods))
                return _memo[periods];

            double result = FutureValueMemoized(presentValue, growthRate, periods - 1) * (1 + growthRate);
            _memo[periods] = result;
            return result;
        }

        public static void ClearMemo() => _memo.Clear();

        // Iterative (Optimized): O(n) time, O(1) space — no stack overhead
        public static double FutureValueIterative(double presentValue, double growthRate, int periods)
        {
            double value = presentValue;
            for (int i = 0; i < periods; i++)
                value *= (1 + growthRate);
            return value;
        }

        // Multi-rate Recursive: each period has its own growth rate
        public static double FutureValueMultiRate(double presentValue, double[] growthRates, int period)
        {
            if (period == 0)
                return presentValue;

            return FutureValueMultiRate(presentValue, growthRates, period - 1) * (1 + growthRates[period - 1]);
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            double presentValue = 10000.0;
            double growthRate   = 0.08;
            int    periods      = 5;

            Console.WriteLine("=== FINANCIAL FORECASTING ===");
            Console.WriteLine($"Present Value : ${presentValue:F2}");
            Console.WriteLine($"Growth Rate   : {growthRate * 100}% per period");
            Console.WriteLine($"Periods       : {periods}");

            Console.WriteLine("\n=== SIMPLE RECURSION ===");
            for (int p = 1; p <= periods; p++)
            {
                double fv = FinancialForecast.FutureValueRecursive(presentValue, growthRate, p);
                Console.WriteLine($"Period {p}: ${fv:F2}");
            }

            Console.WriteLine("\n=== MEMOIZED RECURSION ===");
            FinancialForecast.ClearMemo();
            for (int p = 1; p <= periods; p++)
            {
                double fv = FinancialForecast.FutureValueMemoized(presentValue, growthRate, p);
                Console.WriteLine($"Period {p}: ${fv:F2}");
            }

            Console.WriteLine("\n=== ITERATIVE (OPTIMIZED) ===");
            for (int p = 1; p <= periods; p++)
            {
                double fv = FinancialForecast.FutureValueIterative(presentValue, growthRate, p);
                Console.WriteLine($"Period {p}: ${fv:F2}");
            }

            Console.WriteLine("\n=== MULTI-RATE RECURSION ===");
            double[] rates = { 0.05, 0.08, 0.10, 0.07, 0.09 };
            for (int p = 1; p <= rates.Length; p++)
            {
                double fv = FinancialForecast.FutureValueMultiRate(presentValue, rates, p);
                Console.WriteLine($"Period {p} (rate {rates[p-1]*100}%): ${fv:F2}");
            }

            Console.WriteLine("\n=== TIME COMPLEXITY ANALYSIS ===");
            Console.WriteLine($"{"Approach",-25} {"Time",-12} {"Space",-12} {"Stack Risk"}");
            Console.WriteLine($"{"────────",-25} {"────",-12} {"─────",-12} {"──────────"}");
            Console.WriteLine($"{"Simple Recursive",-25} {"O(n)",-12} {"O(n)",-12} {"Yes — deep n"}");
            Console.WriteLine($"{"Memoized Recursive",-25} {"O(n)",-12} {"O(n)",-12} {"Reduced"}");
            Console.WriteLine($"{"Iterative",-25} {"O(n)",-12} {"O(1)",-12} {"None"}");
            Console.WriteLine($"{"Multi-Rate Recursive",-25} {"O(n)",-12} {"O(n)",-12} {"Yes — deep n"}");
        }
    }
}