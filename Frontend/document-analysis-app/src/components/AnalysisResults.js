import React, { useEffect, useState } from "react";
import { AiOutlineLoading3Quarters } from "react-icons/ai";


const API_URL = "https://your-api-gateway-url.amazonaws.com/results";

const AnalysisResults = ({ userId }) => {
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    setLoading(true);
    fetch(`${API_URL}?user_id=${userId}`)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Failed to fetch results.");
        }
        return response.json();
      })
      .then((data) => {
        setResults(data);
        setLoading(false);
      })
      .catch((error) => {
        setError(error.message);
        setLoading(false);
      });
  }, [userId]);

  return (
    <div className="max-w-3xl mx-auto p-4 bg-white shadow-lg rounded-lg">
      <h2 className="text-2xl font-bold mb-4">Analysis Results</h2>

      {loading ? (
        <div className="flex items-center justify-center">
          <AiOutlineLoading3Quarters className="animate-spin text-3xl text-blue-500" />
          <p className="ml-2 text-gray-700">Loading results...</p>
        </div>
      ) : error ? (
        <p className="text-red-500">{error}</p>
      ) : results.length === 0 ? (
        <p className="text-gray-600">No analysis results found.</p>
      ) : (
        <ul className="space-y-4">
          {results.map((result) => (
            <li
              key={result.document_id}
              className="p-4 border rounded-lg bg-gray-100"
            >
              <h3 className="font-semibold text-lg">{result.document_name}</h3>
              <pre className="bg-gray-200 p-2 rounded text-sm">
                {JSON.stringify(result.analysis_result, null, 2)}
              </pre>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default AnalysisResults;