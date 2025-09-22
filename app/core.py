from datetime import date, timedelta
from typing import List, Dict, Any
from controller.planner import Planner  # <- your existing
from models import Itinerary  # <- your existing Pydantic models

def plan_trip_core(origin: str, destination: str, start_date: date, end_date: date,
                   budget_per_night: float, interests: List[str]) -> Dict[str, Any]:
    planner = Planner()
    it: Itinerary = planner.plan_trip(
        origin=origin,
        destination=destination,
        start_date=start_date,
        end_date=end_date,
        budget_per_night=budget_per_night,
        interests=interests,
    )
    # Return plain dict (FastAPI will serialize it)
    return it.model_dump()
